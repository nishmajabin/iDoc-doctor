import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository _repository;
  final String channelName;
  final String doctorId;
  final String patientUserId;
  final String doctorName;
  final String patientName;
  final String? doctorProfileImageUrl;

  Timer? _timer;
  int _elapsedSeconds = 0;
  StreamSubscription<String?>? _callStatusSub;

  CallRepository get repository => _repository;

  CallBloc({
    required CallRepository repository,
    required this.channelName,
    required this.doctorId,
    required this.patientUserId,
    required this.doctorName,
    required this.patientName,
    this.doctorProfileImageUrl,
  })  : _repository = repository,
        super(const CallInitial()) {
    on<CallJoinRequested>(_onJoinRequested);
    on<CallLeaveRequested>(_onLeaveRequested);
    on<RemoteUserJoined>(_onRemoteUserJoined);
    on<RemoteUserLeft>(_onRemoteUserLeft);
    on<CallMuteToggled>(_onMuteToggled);
    on<CallCameraSwitched>(_onCameraSwitched);
    on<CallTimerTicked>(_onTimerTicked);
    on<CallErrorOccurred>(_onErrorOccurred);
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onJoinRequested(
    CallJoinRequested event,
    Emitter<CallState> emit,
  ) async {
    emit(const CallJoining());

    try {
      await _repository.createCallDocument(
        appointmentId: event.channelName,
        doctorId: doctorId,
        userId: patientUserId,
        doctorName: doctorName,
        patientName: patientName,
        doctorProfileImageUrl: doctorProfileImageUrl,
      );

      debugPrint('📝 [CallBloc] Call document created for userId=$patientUserId');

      _callStatusSub?.cancel();
      _callStatusSub = _repository
          .watchCallStatus(callId: event.channelName)
          .listen((status) {
        debugPrint('🔄 [CallBloc] Call status changed: $status');
        if (isClosed) return;
        if (status == 'rejected') {
          add(const CallErrorOccurred('Patient declined the call.'));
        }
      });

      await _repository.initAndJoin(
        appId: event.appId,
        channelName: event.channelName,
        userId: doctorId,
        onRemoteUserJoined: (uid) {
          if (!isClosed) add(RemoteUserJoined(uid));
        },
        onRemoteUserLeft: (uid) {
          if (!isClosed) add(RemoteUserLeft(uid));
        },
        onError: (msg) {
          if (!isClosed) add(CallErrorOccurred(msg));
        },
      );

      _startTimer();
      emit(const CallWaitingForPeer());
    } catch (e) {
      debugPrint('❌ [CallBloc] Join failed: $e');
      emit(CallError(e.toString()));
    }
  }

  Future<void> _onLeaveRequested(
    CallLeaveRequested event,
    Emitter<CallState> emit,
  ) async {
    _stopTimer();
    await _callStatusSub?.cancel();
    _callStatusSub = null;

    try {
      await _repository.endCallDocument(callId: channelName);
    } catch (e) {
      debugPrint('⚠️ [CallBloc] endCallDocument error (non-fatal): $e');
    }

    await _repository.leaveAndDispose();
    emit(const CallEnded());
  }

  void _onRemoteUserJoined(RemoteUserJoined event, Emitter<CallState> emit) {
    emit(CallActive(
      remoteUid: event.uid,
      isMuted: _getMutedFromState(state),
      elapsedSeconds: _elapsedSeconds,
    ));
  }

  void _onRemoteUserLeft(RemoteUserLeft event, Emitter<CallState> emit) {
    final lastRemoteUid =
        state is CallActive ? (state as CallActive).remoteUid : null;

    emit(CallPeerLeft(
      remoteUid: lastRemoteUid,
      elapsedSeconds: _elapsedSeconds,
    ));
  }

  Future<void> _onMuteToggled(
    CallMuteToggled event,
    Emitter<CallState> emit,
  ) async {
    final newMuted = !_getMutedFromState(state);
    await _repository.muteLocalAudio(mute: newMuted);

    if (state is CallActive) {
      emit((state as CallActive).copyWith(isMuted: newMuted));
    } else if (state is CallWaitingForPeer) {
      emit((state as CallWaitingForPeer).copyWith(isMuted: newMuted));
    }
  }

  Future<void> _onCameraSwitched(
    CallCameraSwitched event,
    Emitter<CallState> emit,
  ) async {
    await _repository.switchCamera();
  }

  void _onTimerTicked(CallTimerTicked event, Emitter<CallState> emit) {
    _elapsedSeconds = event.seconds;
    if (state is CallActive) {
      emit((state as CallActive).copyWith(elapsedSeconds: event.seconds));
    } else if (state is CallWaitingForPeer) {
      emit((state as CallWaitingForPeer).copyWith(elapsedSeconds: event.seconds));
    }
  }

  void _onErrorOccurred(CallErrorOccurred event, Emitter<CallState> emit) {
    _stopTimer();
    emit(CallError(event.message));
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    _elapsedSeconds = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isClosed) add(CallTimerTicked(t.tick));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  bool _getMutedFromState(CallState s) {
    if (s is CallActive) return s.isMuted;
    if (s is CallWaitingForPeer) return s.isMuted;
    return false;
  }

  @override
  Future<void> close() async {
    _stopTimer();
    await _callStatusSub?.cancel();
    await _repository.leaveAndDispose();
    return super.close();
  }
}