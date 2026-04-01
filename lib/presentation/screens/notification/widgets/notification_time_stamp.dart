import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:intl/intl.dart';

class NotificationTimeStamp extends StatelessWidget {
  final DateTime timestamp;

  const NotificationTimeStamp({required this.timestamp, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded, size: 13, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          _formatTime(timestamp),
          style: const TextStyle(
            fontSize: 11.5,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('h:mm a').format(dt);
  }
}