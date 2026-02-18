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
  bool _isEngineCreated = false;
  bool _isJoined = false;

  // ── Cached view widgets ───────────────────────────────────────────────────
  //
  // WHY THIS IS CRITICAL:
  // AgoraVideoView creates a platform view backed by a SurfaceProducer (Android
  // 15 / Flutter 3.19+). A new widget instance = a new platform view = a new
  // Surface. When the old Surface is destroyed the entire video pipeline resets.
  //
  // Without caching, every BLoC state rebuild (mute toggle, timer tick, state
  // type change) destroys and recreates the surface → black screen.
  //
  // With caching, the same AgoraVideoView instance is returned every time, so
  // Flutter reconciles it by object identity and never tears down the Surface.
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

  Future<void> initAndJoin({
    required String appId,
    required String channelName,
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
      _engine!.registerEventHandler(
        RtcEngineEventHandler(
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
        ),
      );

      debugPrint('🎥 [CallRepository] Starting camera preview');
      await _engine!.startPreview();

      if (!_isJoined) {
        _isJoined = true;
        debugPrint('🚀 [CallRepository] Joining channel: $channelName');
        await _engine!.joinChannel(
          token: '',
          channelId: channelName,
          uid: 0,
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
        _engine!.unregisterEventHandler(RtcEngineEventHandler());

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

  // ── Cached view builders ──────────────────────────────────────────────────
  //
  // setupMode: videoViewSetupAdd
  //   Keeps the native Surface alive across widget rebuilds. Do NOT use
  //   videoViewSetupReplace — that intentionally tears the surface down,
  //   which is exactly the black screen bug.
  //
  // renderMode: renderModeHidden (remote) / renderModeFit (local)
  //   renderModeHidden = cover/crop — fills the container, no letterbox bars.
  //   renderModeFit    = letterbox  — fits entirely, good for small PIP.
  //
  // No useFlutterTexture / useAndroidSurfaceView overrides.
  //   Flutter 3.19+ uses SurfaceProducer. Forcing SurfaceView overrides this
  //   and causes a surface mismatch → permanent black. Let system negotiate.

  Widget buildLocalView() {
    if (_engine == null) {
      debugPrint('⚠️ [CallRepository] buildLocalView called with null engine');
      return const SizedBox.shrink();
    }
    return _cachedLocalView ??= AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(
          uid: 0,
          setupMode: VideoViewSetupMode.videoViewSetupAdd,
          renderMode: RenderModeType.renderModeFit,
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