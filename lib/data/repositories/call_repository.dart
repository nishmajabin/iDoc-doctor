import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef OnRemoteUserJoined = void Function(int uid);
typedef OnRemoteUserLeft = void Function(int uid);
typedef OnError = void Function(String message);

class CallRepository {
  final FirebaseFirestore _firestore;

  CallRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  RtcEngine? _engine;
  RtcEngineEventHandler? _eventHandler;
  bool _isEngineCreated = false;
  bool _isJoined = false;


  Widget? _cachedLocalView;
  Widget? _cachedRemoteView;
  int? _cachedRemoteUid;
  String? _cachedRemoteChannel;

  // ── Firestore signaling ───────────────────────────────────────────────────

  Future<void> createCallDocument({
    required String appointmentId,
    required String doctorId,
    required String userId,
    required String doctorName,
    required String patientName,
    String? doctorProfileImageUrl,
  }) async {
    debugPrint('📝 [CallRepository] Creating call document:');
    debugPrint('   appointmentId=$appointmentId');
    debugPrint('   doctorId=$doctorId');
    debugPrint('   userId=$userId');

    await _firestore.collection('calls').doc(appointmentId).set({
      'callId': appointmentId,
      'channelName': appointmentId,
      'doctorId': doctorId,
      'userId': userId,
      'doctorName': doctorName,
      'patientName': patientName,
      'doctorProfileImageUrl': doctorProfileImageUrl,
      'status': 'ringing',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint('✅ [CallRepository] Call document created');
  }

  Stream<String?> watchCallStatus({required String callId}) {
    return _firestore
        .collection('calls')
        .doc(callId)
        .snapshots()
        .map((doc) =>
            doc.exists ? (doc.data() ?? {})['status'] as String? : null);
  }

  Future<void> endCallDocument({required String callId}) async {
    await _firestore.collection('calls').doc(callId).update({
      'status': 'ended',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Agora engine ──────────────────────────────────────────────────────────

  /// Derives a deterministic, non-zero UID from any string (e.g. doctorId).
  /// Because doctorId ≠ patientId, the UIDs are guaranteed to differ.
  static int _uidFromString(String id) {
    var uid = id.hashCode & 0x7FFFFFFF;
    if (uid == 0) uid = 1; // Agora treats 0 as "auto-assign"
    return uid;
  }

  Future<void> initAndJoin({
    required String appId,
    required String channelName,
    required String userId,
    required OnRemoteUserJoined onRemoteUserJoined,
    required OnRemoteUserLeft onRemoteUserLeft,
    required OnError onError,
  }) async {
    if (_isEngineCreated) {
      debugPrint('⚠️ [CallRepository] Engine already created, skipping');
      return;
    }

    try {
      debugPrint('🎬 [CallRepository] Creating RTC engine');
      _engine = createAgoraRtcEngine();
      _isEngineCreated = true;

      debugPrint('🔧 [CallRepository] Initializing engine with appId');
      await _engine!.initialize(RtcEngineContext(appId: appId));

      debugPrint('📹 [CallRepository] Enabling video');
      await _engine!.enableVideo();

      debugPrint('🔊 [CallRepository] Setting channel profile');
      await _engine!.setChannelProfile(
        ChannelProfileType.channelProfileCommunication,
      );

      debugPrint('📡 [CallRepository] Registering event handlers');
      _eventHandler = RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          debugPrint('❌ [Agora] Error ${err.name}: $msg');
          onError('Agora error ${err.name}: $msg');
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
              '✅ [Agora] Joined channel: ${connection.channelId} after ${elapsed}ms');
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint('👤 [Agora] Remote user joined: $remoteUid');
          onRemoteUserJoined(remoteUid);
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint(
              '👋 [Agora] Remote user left: $remoteUid (${reason.name})');
          onRemoteUserLeft(remoteUid);
        },
        onLocalVideoStateChanged: (VideoSourceType source,
            LocalVideoStreamState state,
            LocalVideoStreamReason reason) {
          debugPrint(
              '📹 [Agora] Local video state: ${state.name} reason: ${reason.name}');
        },
        onRemoteVideoStateChanged: (RtcConnection connection,
            int remoteUid,
            RemoteVideoState state,
            RemoteVideoStateReason reason,
            int elapsed) {
          debugPrint(
              '📺 [Agora] Remote video state: ${state.name} reason: ${reason.name}');
        },
        onFirstRemoteVideoFrame: (RtcConnection connection, int remoteUid,
            int width, int height, int elapsed) {
          debugPrint(
              '🖼️ [Agora] First remote frame: uid=$remoteUid ${width}x$height');
        },
      );
      _engine!.registerEventHandler(_eventHandler!);

      debugPrint('🎥 [CallRepository] Starting camera preview');
      await _engine!.startPreview();

      if (!_isJoined) {
        _isJoined = true;
        final localUid = _uidFromString(userId);
        debugPrint('🚀 [CallRepository] Joining channel: $channelName with uid=$localUid (from userId=$userId)');
        await _engine!.joinChannel(
          token: '',
          channelId: channelName,
          uid: localUid,
          options: const ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: ChannelProfileType.channelProfileCommunication,
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
          ),
        );
        debugPrint('✅ [CallRepository] Join channel request sent');
      }
    } catch (e, stack) {
      debugPrint('❌ [CallRepository] Init failed: $e');
      debugPrint('Stack: $stack');
      _isEngineCreated = false;
      _isJoined = false;
      rethrow;
    }
  }

  Future<void> leaveAndDispose() async {
    if (!_isEngineCreated) {
      debugPrint('⚠️ [CallRepository] Engine not created, nothing to dispose');
      return;
    }

    debugPrint('🛑 [CallRepository] Starting cleanup');
    _isEngineCreated = false;
    _isJoined = false;

    // Clear cached views — must be fresh for any subsequent call.
    _cachedLocalView = null;
    _cachedRemoteView = null;
    _cachedRemoteUid = null;
    _cachedRemoteChannel = null;

    try {
      if (_engine != null) {
        debugPrint('👋 [CallRepository] Leaving channel');
        await _engine!.leaveChannel();

        debugPrint('🎥 [CallRepository] Stopping preview');
        await _engine!.stopPreview();

        debugPrint('📡 [CallRepository] Unregistering handlers');
        if (_eventHandler != null) {
          _engine!.unregisterEventHandler(_eventHandler!);
          _eventHandler = null;
        }

        debugPrint('🗑️ [CallRepository] Releasing engine');
        await _engine!.release();
      }
    } catch (e) {
      debugPrint('⚠️ [CallRepository] Disposal error (non-fatal): $e');
    } finally {
      _engine = null;
      debugPrint('✅ [CallRepository] Cleanup complete');
    }
  }

  Future<void> muteLocalAudio({required bool mute}) async {
    if (_engine == null) return;
    await _engine!.muteLocalAudioStream(mute);
    debugPrint('🔇 [CallRepository] Audio ${mute ? "muted" : "unmuted"}');
  }

  Future<void> switchCamera() async {
    if (_engine == null) return;
    await _engine!.switchCamera();
    debugPrint('🔄 [CallRepository] Camera switched');
  }

  Widget buildLocalView() {
    if (_engine == null) {
      debugPrint(' [CallRepository] buildLocalView called with null engine');
      return const SizedBox.shrink();
    }
    return _cachedLocalView ??= ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: const VideoCanvas(
            uid: 0,
            setupMode: VideoViewSetupMode.videoViewSetupAdd,
            renderMode: RenderModeType.renderModeFit,
          ),
        ),
      ),
    );
  }

  Widget buildRemoteView({
    required String channelName,
    required int remoteUid,
  }) {
    if (_engine == null) {
      debugPrint(
          '⚠️ [CallRepository] buildRemoteView called with null engine');
      return const SizedBox.shrink();
    }

    // Return the cached instance if the remote participant hasn't changed.
    if (_cachedRemoteView != null &&
        _cachedRemoteUid == remoteUid &&
        _cachedRemoteChannel == channelName) {
      return _cachedRemoteView!;
    }

    debugPrint(
        '🎥 [CallRepository] Creating remote view: uid=$remoteUid channel=$channelName');

    _cachedRemoteUid = remoteUid;
    _cachedRemoteChannel = channelName;
    _cachedRemoteView = AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(
          uid: remoteUid,
          setupMode: VideoViewSetupMode.videoViewSetupAdd,
          // renderModeHidden = fill full screen (cover/crop).
          // Use renderModeFit if you prefer letterboxing.
          renderMode: RenderModeType.renderModeHidden,
        ),
        connection: RtcConnection(channelId: channelName),
      ),
    );
    return _cachedRemoteView!;
  }

  bool get isReady => _engine != null && _isEngineCreated;
}