import 'package:equatable/equatable.dart';

abstract class CallState extends Equatable {
  const CallState();

  @override
  List<Object?> get props => [];
}

/// Initial state – nothing has happened yet.
class CallInitial extends CallState {
  const CallInitial();
}

/// Engine is being set up / channel is being joined.
class CallJoining extends CallState {
  const CallJoining();
}

/// Successfully joined the channel. Waiting for remote peer.
class CallWaitingForPeer extends CallState {
  final bool isMuted;
  final int elapsedSeconds;

  const CallWaitingForPeer({
    this.isMuted = false,
    this.elapsedSeconds = 0,
  });

  CallWaitingForPeer copyWith({bool? isMuted, int? elapsedSeconds}) {
    return CallWaitingForPeer(
      isMuted: isMuted ?? this.isMuted,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  @override
  List<Object?> get props => [isMuted, elapsedSeconds];
}

/// Both parties are connected and the call is live.
class CallActive extends CallState {
  final int remoteUid;
  final bool isMuted;
  final int elapsedSeconds;

  const CallActive({
    required this.remoteUid,
    this.isMuted = false,
    this.elapsedSeconds = 0,
  });

  CallActive copyWith({int? remoteUid, bool? isMuted, int? elapsedSeconds}) {
    return CallActive(
      remoteUid: remoteUid ?? this.remoteUid,
      isMuted: isMuted ?? this.isMuted,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  @override
  List<Object?> get props => [remoteUid, isMuted, elapsedSeconds];
}

/// Remote user has left the call.
class CallPeerLeft extends CallState {
  final int elapsedSeconds;

  const CallPeerLeft({this.elapsedSeconds = 0});

  @override
  List<Object?> get props => [elapsedSeconds];
}

/// Call ended cleanly (local user hung up).
class CallEnded extends CallState {
  const CallEnded();
}

/// An error occurred in the call flow.
class CallError extends CallState {
  final String message;

  const CallError(this.message);

  @override
  List<Object?> get props => [message];
}