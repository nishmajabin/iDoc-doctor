import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/core/utils/time_utils.dart';

class SlotInfoBox extends StatelessWidget {
  final SlotModel slot;

  const SlotInfoBox({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final remainingMinutes =
        (60 - getHoursSinceCreation(slot.createdAt) * 60)
            .clamp(0, 60)
            .toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.info_outline,
            text:
                'Date: ${DateFormat('MMM dd, yyyy').format(slot.date)}',
          ),
          _infoRow(
            icon: Icons.access_time,
            text:
                'Created: ${DateFormat('MMM dd, HH:mm').format(slot.createdAt)}',
          ),
          _infoRow(
            icon: Icons.timer,
            text: 'Time remaining: $remainingMinutes min',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
