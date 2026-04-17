import 'package:flutter/material.dart';

class AppointmentStatusBadge extends StatelessWidget {
  final String status;

  const AppointmentStatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, IconData icon, String label) =
        switch (status.toLowerCase()) {
      'confirmed' => (
          const Color(0xFF0096C7),
          const Color(0xFFE0F4FF),
          Icons.check_circle_outline_rounded,
          'Confirmed',
        ),
      'pending' => (
          const Color(0xFFE07B00),
          const Color(0xFFFFF3E0),
          Icons.access_time_rounded,
          'Pending',
        ),
      'completed' => (
          const Color(0xFF2D9E6B),
          const Color(0xFFE8F8F1),
          Icons.task_alt_rounded,
          'Done',
        ),
      'cancelled' => (
          const Color(0xFFD13D3D),
          const Color(0xFFFFEBEB),
          Icons.cancel_outlined,
          'Cancelled',
        ),
      _ => (
          const Color(0xFF6B7A91),
          const Color(0xFFEEF2F7),
          Icons.info_outline_rounded,
          status,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}