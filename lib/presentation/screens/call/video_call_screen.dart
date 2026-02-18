import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelName;
  final String patientName;

  const VideoCallScreen({
    super.key,
    required this.channelName,
    required this.patientName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late final CallRepository _repository;

  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    _repository = context.read<CallBloc>().repository;
  }

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _onEndCall() =>
      context.read<CallBloc>().add(const CallLeaveRequested());
  void _onToggleMute() =>
      context.read<CallBloc>().add(const CallMuteToggled());
  void _onSwitchCamera() =>
      context.read<CallBloc>().add(const CallCameraSwitched());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) _onEndCall();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: BlocConsumer<CallBloc, CallState>(
          listenWhen: (_, curr) => curr is CallEnded || curr is CallError,
          listener: (context, state) => Navigator.of(context).pop(),
          // ── KEY RULE: Exclude timer ticks from this builder ──────────────
          //
          // Timer ticks update elapsedSeconds every second. If they triggered
          // a rebuild here, the entire flat Stack would rebuild, which causes
          // Flutter to re-evaluate every `if` condition and potentially move
          // platform views in the render tree — even if their key stays the
          // same, a position change can force a detach/reattach of the
          // SurfaceProducer → black flash.
          //
          // The timer badge is in its own isolated BlocBuilder in _buildTopBar
          // so ONLY the badge widget rebuilds each second.
          buildWhen: (prev, curr) {
            // Track remote uid before deciding to rebuild.
            if (curr is CallActive) _remoteUid = curr.remoteUid;

            if (prev.runtimeType != curr.runtimeType) return true;
            if (prev is CallActive && curr is CallActive) {
              return prev.remoteUid != curr.remoteUid ||
                  prev.isMuted != curr.isMuted;
            }
            if (prev is CallWaitingForPeer && curr is CallWaitingForPeer) {
              return prev.isMuted != curr.isMuted;
            }
            return true;
          },
          builder: (context, state) {
            final bool isMuted = switch (state) {
              CallActive s => s.isMuted,
              CallWaitingForPeer s => s.isMuted,
              _ => false,
            };
            final bool toolbarEnabled = state is CallActive ||
                state is CallWaitingForPeer ||
                state is CallPeerLeft;

            // ── FLAT STACK with stable ValueKeys ──────────────────────────
            //
            // Every child is a direct Positioned inside a single flat Stack.
            // Each has a const ValueKey so Flutter reconciles by key identity
            // regardless of how many siblings appear/disappear.
            //
            // WHY FLAT MATTERS:
            // The old approach returned either `background` or
            // `Stack([background, remoteVideo])` from _buildRemoteView().
            // That structural change caused Flutter to unmatch the local pip
            // Positioned across state transitions → local PIP recreated →
            // new platform view → OLD surface torn down → black PIP.
            //
            // With a flat Stack + keys, the local pip Positioned is always
            // at the same conceptual slot and Flutter never recreates it.
            return Stack(
              fit: StackFit.expand,
              children: [

                // ── 1. Background gradient ───────────────────────────────
                const Positioned.fill(
                  key: ValueKey('bg'),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                      ),
                    ),
                  ),
                ),

                // ── 2. Remote video — full screen ────────────────────────
                //
                // Shown as soon as we have a remote uid and engine is ready.
                // The cached widget from _repository.buildRemoteView() ensures
                // the same platform view instance is always used — no surface
                // teardown on rebuild.
                if (_remoteUid != null && _repository.isReady)
                  Positioned.fill(
                    key: const ValueKey('remote_video'),
                    child: _repository.buildRemoteView(
                      channelName: widget.channelName,
                      remoteUid: _remoteUid!,
                    ),
                  ),

                if (_repository.isReady &&
                    state is! CallJoining &&
                    state is! CallInitial &&
                    state is! CallEnded &&
                    state is! CallError)
                  Positioned(
                    key: const ValueKey('local_pip'),
                    top: 100,
                    right: 16,
                    width: 110,
                    height: 160,
                    child: Stack(
                      children: [
                        // Actual video surface — no clipping.
                        Positioned.fill(
                          child: _repository.buildLocalView(),
                        ),
                        // Decorative rounded border in Flutter layer tree.
                        // Renders correctly on top of hardware overlays.
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.white24, width: 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── 4. Top bar ───────────────────────────────────────────
                Positioned(
                  key: const ValueKey('top_bar'),
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildTopBar(state),
                ),

                // ── 5. Bottom toolbar ────────────────────────────────────
                Positioned(
                  key: const ValueKey('toolbar'),
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildToolbar(isMuted, toolbarEnabled),
                ),

                // ── 6. Overlay messages ──────────────────────────────────
                if (_buildOverlay(state) case final overlay
                    when overlay != null)
                  Positioned.fill(
                    key: const ValueKey('overlay'),
                    child: overlay,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(CallState state) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.patientName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                _buildStatusChip(state),
              ],
            ),
            // Isolated BlocBuilder — ONLY this badge rebuilds every second.
            // The parent buildWhen blocks timer ticks from the full Stack,
            // so platform view positions are never disturbed by the clock.
            if (state is CallActive ||
                state is CallWaitingForPeer ||
                state is CallPeerLeft)
              BlocBuilder<CallBloc, CallState>(
                buildWhen: (prev, curr) {
                  final ps = prev is CallActive
                      ? prev.elapsedSeconds
                      : prev is CallWaitingForPeer
                          ? prev.elapsedSeconds
                          : -1;
                  final cs = curr is CallActive
                      ? curr.elapsedSeconds
                      : curr is CallWaitingForPeer
                          ? curr.elapsedSeconds
                          : -1;
                  return ps != cs;
                },
                builder: (_, ts) {
                  final secs = ts is CallActive
                      ? ts.elapsedSeconds
                      : ts is CallWaitingForPeer
                          ? ts.elapsedSeconds
                          : 0;
                  return _TimerBadge(duration: _formatDuration(secs));
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(CallState state) {
    final (String label, Color color) = switch (state) {
      CallJoining() => ('Connecting…', Colors.orange),
      CallWaitingForPeer() => ('Waiting for patient…', Colors.yellowAccent),
      CallActive() => ('In call', Colors.greenAccent),
      CallPeerLeft() => ('Patient left', Colors.redAccent),
      _ => ('', Colors.transparent),
    };
    if (label.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  // ── Toolbar ───────────────────────────────────────────────────────────────

  Widget _buildToolbar(bool isMuted, bool toolbarEnabled) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 30, top: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CallButton(
              icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
              label: isMuted ? 'Unmute' : 'Mute',
              background: isMuted ? Colors.white : Colors.white24,
              iconColor: isMuted ? Colors.black : Colors.white,
              onPressed: toolbarEnabled ? _onToggleMute : null,
            ),
            _CallButton(
              icon: Icons.call_end_rounded,
              label: 'End',
              background: Colors.red,
              iconColor: Colors.white,
              size: 64,
              onPressed: _onEndCall,
            ),
            _CallButton(
              icon: Icons.flip_camera_ios_rounded,
              label: 'Flip',
              background: Colors.white24,
              iconColor: Colors.white,
              onPressed: toolbarEnabled ? _onSwitchCamera : null,
            ),
          ],
        ),
      ),
    );
  }

  // ── Overlay — returns null when nothing to show (no ghost SizedBox) ───────

  Widget? _buildOverlay(CallState state) {
    if (state is CallJoining) {
      return const _CenteredMessage(
        icon: Icons.videocam_rounded,
        title: 'Connecting…',
        subtitle: 'Setting up secure video connection',
        showSpinner: true,
      );
    }
    if (state is CallWaitingForPeer) {
      return const _CenteredMessage(
        icon: Icons.person_outline_rounded,
        title: 'Waiting for patient to join',
        subtitle: 'The patient will join shortly',
        showSpinner: true,
      );
    }
    if (state is CallPeerLeft) {
      return const _CenteredMessage(
        icon: Icons.call_end_rounded,
        title: 'Patient left the call',
        subtitle: 'You can end the call or wait for reconnection',
      );
    }
    if (state is CallError) {
      return _CenteredMessage(
        icon: Icons.error_outline_rounded,
        title: 'Connection error',
        subtitle: state.message,
        iconColor: Colors.redAccent,
      );
    }
    return null; // CallActive — no overlay, full video visible
  }
}

// ── Call button ───────────────────────────────────────────────────────────────

class _CallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color iconColor;
  final VoidCallback? onPressed;
  final double size;

  const _CallButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.iconColor,
    this.onPressed,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: onPressed == null ? Colors.white12 : background,
              shape: BoxShape.circle,
              boxShadow: onPressed != null
                  ? [
                      BoxShadow(
                        color: background.withValues(alpha: .4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: size * 0.42),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: onPressed == null ? Colors.white38 : Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// ── Timer badge ───────────────────────────────────────────────────────────────

class _TimerBadge extends StatelessWidget {
  final String duration;
  const _TimerBadge({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.greenAccent, size: 8),
          const SizedBox(width: 6),
          Text(
            duration,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Overlay message ───────────────────────────────────────────────────────────

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showSpinner;
  final Color iconColor;

  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showSpinner = false,
    this.iconColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: const Color(0xCC0D0D0D),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: iconColor),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
              if (showSpinner) ...[
                const SizedBox(height: 24),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white38,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}