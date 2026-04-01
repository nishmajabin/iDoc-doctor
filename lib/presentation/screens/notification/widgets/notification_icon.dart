import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_type_visual.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationTypeVisual typeData;

  const NotificationIcon({required this.typeData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: typeData.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(typeData.icon, color: typeData.color, size: 22),
    );
  }
}



