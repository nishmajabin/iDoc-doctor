import 'package:equatable/equatable.dart';

abstract class CallEvent extends Equatable {
  const CallEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the doctor initiates or joins a channel.
class CallJoinRequested extends CallEvent {
  final String channelName;
  final String appId;

  const CallJoinRequested({
    required this.channelName,
    required this.appId,
  });

  @override
  List<Object?> get props => [channelName, appId];
}

/// Fired when the call screen is about to be disposed / back button pressed.
class CallLeaveRequested extends CallEvent {
  const CallLeaveRequested();
}

/// Fired by Agora callback when a remote user joins.
class RemoteUserJoined extends CallEvent {
  final int uid;

  const RemoteUserJoined(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// Fired by Agora callback when a remote user leaves.
class RemoteUserLeft extends CallEvent {
  final int uid;

  const RemoteUserLeft(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// Toggle mute/unmute of local audio stream.
class CallMuteToggled extends CallEvent {
  const CallMuteToggled();
}

/// Switch between front/rear camera.
class CallCameraSwitched extends CallEvent {
  const CallCameraSwitched();
}

/// Internal tick to update the call-duration counter every second.
class CallTimerTicked extends CallEvent {
  final int seconds;

  const CallTimerTicked(this.seconds);

  @override
  List<Object?> get props => [seconds];
}

/// Fired when an Agora engine error occurs.
class CallErrorOccurred extends CallEvent {
  final String message;

  const CallErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}