import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_time_stamp.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_type_badge.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_type_visual.dart';

class NotificationContent extends StatelessWidget {
  final NotificationItemModel notification;
  final NotificationTypeVisual typeData;

  const NotificationContent({
    required this.notification,
    required this.typeData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight:
                      notification.isRead ? FontWeight.w500 : FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          notification.body,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            NotificationTypeBadge(typeData: typeData),
            const Spacer(),
            NotificationTimeStamp(timestamp: notification.timestamp),
          ],
        ),
      ],
    );
  }
}
