import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_type_visual.dart';

class NotificationTypeBadge extends StatelessWidget {
  final NotificationTypeVisual typeData;

  const NotificationTypeBadge({required this.typeData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: typeData.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        typeData.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: typeData.color,
        ),
      ),
    );
  }
}
