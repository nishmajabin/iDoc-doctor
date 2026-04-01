import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_state.dart';

class CallStatusChip extends StatelessWidget {
  final CallState state;
  const CallStatusChip({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
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
}