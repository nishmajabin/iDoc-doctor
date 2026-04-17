import 'package:flutter/material.dart';

class ConsultationTypeBadge extends StatelessWidget {
  final String type;
  final bool isUpcoming;

  const ConsultationTypeBadge({required this.type, required this.isUpcoming, super.key});

  @override
  Widget build(BuildContext context) {
    final isVideo = type.toLowerCase().contains('video');
    final Color color;
    if (!isUpcoming) {
      color = const Color(0xFF9DAFC2);
    } else if (isVideo) {
      color = const Color(0xFF7B2FF7);
    } else {
      color = const Color(0xFF0077B6);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isVideo
              ? Icons.videocam_outlined
              : Icons.person_outline_rounded,
          size: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          type,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
