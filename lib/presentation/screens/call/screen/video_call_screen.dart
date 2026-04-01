import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/utils/call_state_helpers.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_local_pip.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_toolbar.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_top_bar.dart';

class VideoCallScreen extends StatelessWidget {
  final String channelName;
  final String patientName;

  const VideoCallScreen({
    super.key,
    required this.channelName,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) context.read<CallBloc>().add(const CallLeaveRequested());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: BlocConsumer<CallBloc, CallState>(
          listenWhen: (_, curr) => curr is CallEnded || curr is CallError,
          listener: (context, _) => Navigator.of(context).pop(),
          buildWhen: (prev, curr) {
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
            final repository = context.read<CallBloc>().repository;
            final remoteUid = remoteUidFrom(state);
            final overlay = overlayFor(state);
            
            return Stack(
              fit: StackFit.expand,
              children: [

                // 1. Background gradient
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

                // 2. Remote video — full screen
                if (remoteUid != null && repository.isReady)
                  Positioned.fill(
                    key: const ValueKey('remote_video'),
                    child: repository.buildRemoteView(
                      channelName: channelName,
                      remoteUid: remoteUid,
                    ),
                  ),

                // 3. Local PIP
                if (showLocalView(state, repository))
                  Positioned(
                    key: const ValueKey('local_pip'),
                    top: 100,
                    right: 16,
                    width: 110,
                    height: 160,
                    child: CallLocalPip(
                      localView: repository.buildLocalView(),
                    ),
                  ),

                // 4. Top bar
                Positioned(
                  key: const ValueKey('top_bar'),
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CallTopBar(state: state, patientName: patientName),
                ),

                // 5. Bottom toolbar
                Positioned(
                  key: const ValueKey('toolbar'),
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: CallToolbar(
                    isMuted: isMutedFrom(state),
                    isEnabled: isToolbarEnabled(state),
                  ),
                ),

                // 6. Phase overlay — absent during CallActive
                if (overlay != null)
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
}