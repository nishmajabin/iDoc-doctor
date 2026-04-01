import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';

/// Pure data class — maps a [NotificationType] to its visual representation.
/// Extracted so it can be reused across card, badge, and list widgets.
class NotificationTypeVisual {
  final IconData icon;
  final Color color;
  final String label;

  const NotificationTypeVisual({
    required this.icon,
    required this.color,
    required this.label,
  });

  factory NotificationTypeVisual.from(NotificationType type) =>
      switch (type) {
        NotificationType.appointmentBooked => const NotificationTypeVisual(
            icon: Icons.calendar_today_rounded,
            color: AppColors.confirmed,
            label: 'Appointment',
          ),
        NotificationType.chatMessage => const NotificationTypeVisual(
            icon: Icons.chat_bubble_rounded,
            color: AppColors.accent,
            label: 'Chat',
          ),
        NotificationType.appointmentReminder => const NotificationTypeVisual(
            icon: Icons.alarm_rounded,
            color: AppColors.pending,
            label: 'Reminder',
          ),
        NotificationType.general => const NotificationTypeVisual(
            icon: Icons.info_outline_rounded,
            color: AppColors.textSecondary,
            label: 'General',
          ),
      };
}