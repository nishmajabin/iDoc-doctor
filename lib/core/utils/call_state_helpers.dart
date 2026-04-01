import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_centered_message.dart';

int? remoteUidFrom(CallState state) => switch (state) {
      CallActive s => s.remoteUid,
      CallPeerLeft s => s.remoteUid,
      _ => null,
    };

/// Returns the current local-audio mute status.
bool isMutedFrom(CallState state) => switch (state) {
      CallActive s => s.isMuted,
      CallWaitingForPeer s => s.isMuted,
      _ => false,
    };

/// Whether the mute and flip-camera buttons should be interactive.
bool isToolbarEnabled(CallState state) =>
    state is CallActive ||
    state is CallWaitingForPeer ||
    state is CallPeerLeft;

/// Whether the local PIP view should be rendered.
/// Requires the repository engine to be ready and a mid-call state to be active.
bool showLocalView(CallState state, CallRepository repository) =>
    repository.isReady &&
    state is! CallJoining &&
    state is! CallInitial &&
    state is! CallEnded &&
    state is! CallError;

/// Maps each blocking call phase to a full-screen overlay widget.
/// Returns null during CallActive so the video is fully unobstructed.
Widget? overlayFor(CallState state) => switch (state) {
      CallJoining() => const CallCenteredMessage(
          icon: Icons.videocam_rounded,
          title: 'Connecting…',
          subtitle: 'Setting up secure video connection',
          showSpinner: true,
        ),
      CallWaitingForPeer() => const CallCenteredMessage(
          icon: Icons.person_outline_rounded,
          title: 'Waiting for patient to join',
          subtitle: 'The patient will join shortly',
          showSpinner: true,
        ),
      CallPeerLeft() => const CallCenteredMessage(
          icon: Icons.call_end_rounded,
          title: 'Patient left the call',
          subtitle: 'You can end the call or wait for reconnection',
        ),
      CallError s => CallCenteredMessage(
          icon: Icons.error_outline_rounded,
          title: 'Connection error',
          subtitle: s.message,
          iconColor: Colors.redAccent,
        ),
      _ => null,
    };