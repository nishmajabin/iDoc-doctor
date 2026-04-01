import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_event.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_content.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/widgets/notification_icon.dart';
import 'notification_type_visual.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItemModel notification;
  final String doctorId;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    final typeData = NotificationTypeVisual.from(notification.type);

    return Dismissible(
      key: Key(notification.notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cancelled.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.cancelled,
          size: 26,
        ),
      ),
      onDismissed: (_) => context.read<NotificationHistoryBloc>().add(
            DeleteNotification(
              doctorId: doctorId,
              notificationId: notification.notificationId,
            ),
          ),
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : AppColors.primarySurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.divider
                  : AppColors.primary.withValues(alpha: 0.18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationIcon(typeData: typeData),
              const SizedBox(width: 12),
              Expanded(
                child: NotificationContent(
                  notification: notification,
                  typeData: typeData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (!notification.isRead) {
      context.read<NotificationHistoryBloc>().add(
            MarkNotificationRead(
              doctorId: doctorId,
              notificationId: notification.notificationId,
            ),
          );
    }

    if (notification.data == null) return;

    final snackMsg = switch (notification.type) {
      NotificationType.appointmentBooked ||
      NotificationType.appointmentReminder =>
        'Opening appointment details…',
      NotificationType.chatMessage => 'Opening chat…',
      NotificationType.general => null,
    };

    if (snackMsg != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackMsg),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }
}


