import 'package:agora_rtc_engine/agora_rtc_engine.dart';

typedef OnRemoteUserJoined = void Function(int uid);
typedef OnRemoteUserLeft = void Function(int uid);
typedef OnError = void Function(String message);

class CallEngineHandler {
  static RtcEngineEventHandler build({
    required OnRemoteUserJoined onRemoteUserJoined,
    required OnRemoteUserLeft onRemoteUserLeft,
    required OnError onError,
  }) =>
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) =>
            onError('Agora error ${err.name}: $msg'),
        onJoinChannelSuccess: (_, __) {},
        onUserJoined: (_, int remoteUid, __) => onRemoteUserJoined(remoteUid),
        onUserOffline: (_, int remoteUid, __) => onRemoteUserLeft(remoteUid),
        onLocalVideoStateChanged: (_, __, ___) {},
        onRemoteVideoStateChanged: (_, __, ___, ____, _____) {},
        onFirstRemoteVideoFrame: (_, __, ___, ____, _____) {},
      );
}