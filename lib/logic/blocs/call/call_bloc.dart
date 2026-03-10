// import 'dart:async';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/data/repositories/call_repository.dart';
// import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
// import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';

// class CallBloc extends Bloc<CallEvent, CallState> {
//   final CallRepository _repository;
//   final String channelName;

//   Timer? _timer;
//   int _elapsedSeconds = 0;


//   CallRepository get repository => _repository;

//   CallBloc({
//     required CallRepository repository,
//     required this.channelName,
//   })  : _repository = repository,
//         super(const CallInitial()) {
//     on<CallJoinRequested>(_onJoinRequested);
//     on<CallLeaveRequested>(_onLeaveRequested);
//     on<RemoteUserJoined>(_onRemoteUserJoined);
//     on<RemoteUserLeft>(_onRemoteUserLeft);
//     on<CallMuteToggled>(_onMuteToggled);
//     on<CallCameraSwitched>(_onCameraSwitched);
//     on<CallTimerTicked>(_onTimerTicked);
//     on<CallErrorOccurred>(_onErrorOccurred);
//   }

//   // ── Handlers ────────────────────────────────────────────────────────────────

//   Future<void> _onJoinRequested(
//     CallJoinRequested event,
//     Emitter<CallState> emit,
//   ) async {
//     emit(const CallJoining());

//     try {
//       await _repository.initAndJoin(
//         appId: event.appId,
//         channelName: event.channelName,
//         onRemoteUserJoined: (uid) {
//           // Guard: bloc may have been closed before callback fires.
//           if (!isClosed) add(RemoteUserJoined(uid));
//         },
//         onRemoteUserLeft: (uid) {
//           if (!isClosed) add(RemoteUserLeft(uid));
//         },
//         onError: (msg) {
//           if (!isClosed) add(CallErrorOccurred(msg));
//         },
//       );

//       _startTimer();
//       emit(const CallWaitingForPeer());
//     } catch (e) {
//       emit(CallError(e.toString()));
//     }
//   }

//   Future<void> _onLeaveRequested(
//     CallLeaveRequested event,
//     Emitter<CallState> emit,
//   ) async {
//     _stopTimer();
//     await _repository.leaveAndDispose();
//     emit(const CallEnded());
//   }

//   void _onRemoteUserJoined(
//     RemoteUserJoined event,
//     Emitter<CallState> emit,
//   ) {
//     final current = state;
//     final muted = _getMutedFromState(current);
//     emit(CallActive(
//       remoteUid: event.uid,
//       isMuted: muted,
//       elapsedSeconds: _elapsedSeconds,
//     ));
//   }

//   void _onRemoteUserLeft(
//     RemoteUserLeft event,
//     Emitter<CallState> emit,
//   ) {
//     emit(CallPeerLeft(elapsedSeconds: _elapsedSeconds));
//   }

//   Future<void> _onMuteToggled(
//     CallMuteToggled event,
//     Emitter<CallState> emit,
//   ) async {
//     final newMuted = !_getMutedFromState(state);
//     await _repository.muteLocalAudio(mute: newMuted);

//     final current = state;
//     if (current is CallActive) {
//       emit(current.copyWith(isMuted: newMuted));
//     } else if (current is CallWaitingForPeer) {
//       emit(current.copyWith(isMuted: newMuted));
//     }
//   }

//   Future<void> _onCameraSwitched(
//     CallCameraSwitched event,
//     Emitter<CallState> emit,
//   ) async {
//     await _repository.switchCamera();
//     // No state change needed – video view updates automatically.
//   }

//   void _onTimerTicked(
//     CallTimerTicked event,
//     Emitter<CallState> emit,
//   ) {
//     _elapsedSeconds = event.seconds;
//     final current = state;
//     if (current is CallActive) {
//       emit(current.copyWith(elapsedSeconds: event.seconds));
//     } else if (current is CallWaitingForPeer) {
//       emit(current.copyWith(elapsedSeconds: event.seconds));
//     }
//   }

//   void _onErrorOccurred(
//     CallErrorOccurred event,
//     Emitter<CallState> emit,
//   ) {
//     _stopTimer();
//     emit(CallError(event.message));
//   }

//   // ── Timer helpers ───────────────────────────────────────────────────────────

//   void _startTimer() {
//     _timer?.cancel();
//     _elapsedSeconds = 0;
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!isClosed) add(CallTimerTicked(t.tick));
//     });
//   }

//   void _stopTimer() {
//     _timer?.cancel();
//     _timer = null;
//   }

//   // ── Utilities ───────────────────────────────────────────────────────────────

//   bool _getMutedFromState(CallState s) {
//     if (s is CallActive) return s.isMuted;
//     if (s is CallWaitingForPeer) return s.isMuted;
//     return false;
//   }

//   @override
//   Future<void> close() async {
//     _stopTimer();
//     // Ensure Agora resources are cleaned up if the bloc is closed externally
//     // (e.g. app killed) without a formal CallLeaveRequested event.
//     await _repository.leaveAndDispose();
//     return super.close();
//   }
// }

// FILE: lib/logic/blocs/call/call_bloc.dart  (DOCTOR APP)
//
// Changes vs previous version:
//   • Added patientUserId field — passed to createCallDocument so the user
//     app's Firestore query can find the ringing call.
//   • _onJoinRequested calls createCallDocument BEFORE joining Agora.
//   • _onLeaveRequested marks the doc as 'ended'.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final CallRepository _repository;
  final String channelName;

  // ── NEW: patient info for Firestore signaling ──────────────────────────
  final String doctorId;
  final String patientUserId;   // ← patient's Firebase Auth UID (NOT appointmentId)
  final String doctorName;
  final String patientName;
  final String? doctorProfileImageUrl;
  // ──────────────────────────────────────────────────────────────────────

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
      // STEP 1: Write Firestore doc → triggers IncomingCallScreen on user app.
      await _repository.createCallDocument(
        appointmentId: event.channelName,
        doctorId: doctorId,
        userId: patientUserId,          // ← CRITICAL: must be patient's Firebase uid
        doctorName: doctorName,
        patientName: patientName,
        doctorProfileImageUrl: doctorProfileImageUrl,
      );

      debugPrint('📝 [CallBloc] Call document created for userId=$patientUserId');

      // STEP 2: Watch for user accept/reject.
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

      // STEP 3: Join Agora channel with deterministic UID from doctorId.
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

    // Mark Firestore doc as ended → user app tears down automatically.
    try {
      await _repository.endCallDocument(callId: channelName);
    } catch (e) {
      debugPrint('⚠️ [CallBloc] endCallDocument error (non-fatal): $e');
    }

    await _repository.leaveAndDispose();
    emit(const CallEnded());
  }

  void _onRemoteUserJoined(RemoteUserJoined event, Emitter<CallState> emit) {
    final current = state;
    final muted = _getMutedFromState(current);
    emit(CallActive(
      remoteUid: event.uid,
      isMuted: muted,
      elapsedSeconds: _elapsedSeconds,
    ));
  }

  void _onRemoteUserLeft(RemoteUserLeft event, Emitter<CallState> emit) {
    emit(CallPeerLeft(elapsedSeconds: _elapsedSeconds));
  }

  Future<void> _onMuteToggled(
      CallMuteToggled event, Emitter<CallState> emit) async {
    final newMuted = !_getMutedFromState(state);
    await _repository.muteLocalAudio(mute: newMuted);
    final current = state;
    if (current is CallActive) {
      emit(current.copyWith(isMuted: newMuted));
    } else if (current is CallWaitingForPeer) {
      emit(current.copyWith(isMuted: newMuted));
    }
  }

  Future<void> _onCameraSwitched(
      CallCameraSwitched event, Emitter<CallState> emit) async {
    await _repository.switchCamera();
  }

  void _onTimerTicked(CallTimerTicked event, Emitter<CallState> emit) {
    _elapsedSeconds = event.seconds;
    final current = state;
    if (current is CallActive) {
      emit(current.copyWith(elapsedSeconds: event.seconds));
    } else if (current is CallWaitingForPeer) {
      emit(current.copyWith(elapsedSeconds: event.seconds));
    }
  }

  void _onErrorOccurred(CallErrorOccurred event, Emitter<CallState> emit) {
    _stopTimer();
    emit(CallError(event.message));
  }

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