import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/utils/call_duration_formatter.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_status_chip.dart';
import 'package:idoc_doctor_side/presentation/screens/call/widgets/call_timer_badge.dart';

class CallTopBar extends StatelessWidget {
  final CallState state;
  final String patientName;

  const CallTopBar({
    required this.state,
    required this.patientName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showTimer = state is CallActive ||
        state is CallWaitingForPeer ||
        state is CallPeerLeft;

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
                  patientName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                CallStatusChip(state: state),
              ],
            ),

            // Isolated builder — ONLY this badge rebuilds every second.
            if (showTimer)
              BlocBuilder<CallBloc, CallState>(
                buildWhen: (prev, curr) {
                  final prevSecs = switch (prev) {
                    CallActive s => s.elapsedSeconds,
                    CallWaitingForPeer s => s.elapsedSeconds,
                    _ => -1,
                  };
                  final currSecs = switch (curr) {
                    CallActive s => s.elapsedSeconds,
                    CallWaitingForPeer s => s.elapsedSeconds,
                    _ => -1,
                  };
                  return prevSecs != currSecs;
                },
                builder: (_, timerState) {
                  final secs = switch (timerState) {
                    CallActive s => s.elapsedSeconds,
                    CallWaitingForPeer s => s.elapsedSeconds,
                    _ => 0,
                  };
                  return CallTimerBadge(duration: formatCallDuration(secs));
                },
              ),
          ],
        ),
      ),
    );
  }
}