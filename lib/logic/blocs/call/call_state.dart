import 'package:equatable/equatable.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

class CallInitial extends CallState {
  const CallInitial();
}

class CallJoining extends CallState {
  const CallJoining();
}

class CallWaitingForPeer extends CallState {
  final bool isMuted;
  final int elapsedSeconds;

  const CallWaitingForPeer({
    this.isMuted = false,
    this.elapsedSeconds = 0,
  });

  CallWaitingForPeer copyWith({bool? isMuted, int? elapsedSeconds}) =>
      CallWaitingForPeer(
        isMuted: isMuted ?? this.isMuted,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      );

  @override
  List<Object?> get props => [isMuted, elapsedSeconds];
}

class CallActive extends CallState {
  final int remoteUid;
  final bool isMuted;
  final int elapsedSeconds;

  const CallActive({
    required this.remoteUid,
    this.isMuted = false,
    this.elapsedSeconds = 0,
  });

  CallActive copyWith({int? remoteUid, bool? isMuted, int? elapsedSeconds}) =>
      CallActive(
        remoteUid: remoteUid ?? this.remoteUid,
        isMuted: isMuted ?? this.isMuted,
        elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      );

  @override
  List<Object?> get props => [remoteUid, isMuted, elapsedSeconds];
}

class CallPeerLeft extends CallState {
  final int? remoteUid;
  final int elapsedSeconds;

  const CallPeerLeft({
    this.remoteUid,
    this.elapsedSeconds = 0,
  });

  @override
  List<Object?> get props => [remoteUid, elapsedSeconds];
}

class CallEnded extends CallState {
  const CallEnded();
}

class CallError extends CallState {
  final String message;

  const CallError(this.message);

  @override
  List<Object?> get props => [message];
}