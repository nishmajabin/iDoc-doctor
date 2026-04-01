import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'call_engine_handler.dart';

class CallEngine {
  RtcEngine? _engine;
  RtcEngineEventHandler? _eventHandler;
  bool _isEngineCreated = false;
  bool _isJoined = false;

  Widget? _cachedLocalView;
  Widget? _cachedRemoteView;
  int? _cachedRemoteUid;
  String? _cachedRemoteChannel;

  bool get isReady => _engine != null && _isEngineCreated;

  static int _uidFromString(String id) {
    final uid = id.hashCode & 0x7FFFFFFF;
    return uid == 0 ? 1 : uid;
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void> initAndJoin({
    required String appId,
    required String channelName,
    required String userId,
    required OnRemoteUserJoined onRemoteUserJoined,
    required OnRemoteUserLeft onRemoteUserLeft,
    required OnError onError,
  }) async {
    if (_isEngineCreated) return;

    try {
      _engine = createAgoraRtcEngine();
      _isEngineCreated = true;

      await _engine!.initialize(RtcEngineContext(appId: appId));
      await _engine!.enableVideo();
      await _engine!.setChannelProfile(ChannelProfileType.channelProfileCommunication);

      _eventHandler = CallEngineHandler.build(
        onRemoteUserJoined: onRemoteUserJoined,
        onRemoteUserLeft: onRemoteUserLeft,
        onError: onError,
      );
      _engine!.registerEventHandler(_eventHandler!);

      await _engine!.startPreview();

      if (!_isJoined) {
        _isJoined = true;
        await _engine!.joinChannel(
          token: '',
          channelId: channelName,
          uid: _uidFromString(userId),
          options: const ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleBroadcaster,
            channelProfile: ChannelProfileType.channelProfileCommunication,
            publishCameraTrack: true,
            publishMicrophoneTrack: true,
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
          ),
        );
      }
    } catch (e) {
      _isEngineCreated = false;
      _isJoined = false;
      rethrow;
    }
  }

  Future<void> leaveAndDispose() async {
    if (!_isEngineCreated) return;

    _isEngineCreated = false;
    _isJoined = false;
    _cachedLocalView = null;
    _cachedRemoteView = null;
    _cachedRemoteUid = null;
    _cachedRemoteChannel = null;

    try {
      await _engine?.leaveChannel();
      await _engine?.stopPreview();
      if (_eventHandler != null) {
        _engine?.unregisterEventHandler(_eventHandler!);
        _eventHandler = null;
      }
      await _engine?.release();
    } catch (_) {
    } finally {
      _engine = null;
    }
  }

  // ── Controls ──────────────────────────────────────────────────────────────

  Future<void> muteLocalAudio({required bool mute}) =>
      _engine?.muteLocalAudioStream(mute) ?? Future.value();

  Future<void> switchCamera() =>
      _engine?.switchCamera() ?? Future.value();

  // ── Video views ───────────────────────────────────────────────────────────

  Widget buildLocalView() {
    if (_engine == null) return const SizedBox.shrink();
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

  Widget buildRemoteView({required String channelName, required int remoteUid}) {
    if (_engine == null) return const SizedBox.shrink();

    final isCacheValid = _cachedRemoteView != null &&
        _cachedRemoteUid == remoteUid &&
        _cachedRemoteChannel == channelName;

    if (isCacheValid) return _cachedRemoteView!;

    _cachedRemoteUid = remoteUid;
    _cachedRemoteChannel = channelName;
    return _cachedRemoteView = AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(
          uid: remoteUid,
          setupMode: VideoViewSetupMode.videoViewSetupAdd,
          renderMode: RenderModeType.renderModeHidden,
        ),
        connection: RtcConnection(channelId: channelName),
      ),
    );
  }
}