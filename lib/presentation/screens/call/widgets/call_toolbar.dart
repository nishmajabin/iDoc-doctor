import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_button.dart';

class CallToolbar extends StatelessWidget {
  final bool isMuted;
  final bool isEnabled;

  const CallToolbar({
    required this.isMuted,
    required this.isEnabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CallBloc>();

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
            CallButton(
              icon: isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
              label: isMuted ? 'Unmute' : 'Mute',
              background: isMuted ? Colors.white : Colors.white24,
              iconColor: isMuted ? Colors.black : Colors.white,
              onPressed:
                  isEnabled ? () => bloc.add(const CallMuteToggled()) : null,
            ),
            CallButton(
              icon: Icons.call_end_rounded,
              label: 'End',
              background: Colors.red,
              iconColor: Colors.white,
              size: 64,
              // End call is always tappable regardless of toolbar state.
              onPressed: () => bloc.add(const CallLeaveRequested()),
            ),
            CallButton(
              icon: Icons.flip_camera_ios_rounded,
              label: 'Flip',
              background: Colors.white24,
              iconColor: Colors.white,
              onPressed:
                  isEnabled ? () => bloc.add(const CallCameraSwitched()) : null,
            ),
          ],
        ),
      ),
    );
  }
}