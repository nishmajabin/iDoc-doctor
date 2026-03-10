import 'package:equatable/equatable.dart';

abstract class NotificationHistoryEvent extends Equatable {
  const NotificationHistoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load / start watching notifications for a doctor.
class LoadNotificationHistory extends NotificationHistoryEvent {
  final String doctorId;
  const LoadNotificationHistory({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

/// Mark a single notification as read.
class MarkNotificationRead extends NotificationHistoryEvent {
  final String doctorId;
  final String notificationId;

  const MarkNotificationRead({
    required this.doctorId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [doctorId, notificationId];
}

/// Mark all notifications as read.
class MarkAllNotificationsRead extends NotificationHistoryEvent {
  final String doctorId;
  const MarkAllNotificationsRead({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

/// Delete a single notification.
class DeleteNotification extends NotificationHistoryEvent {
  final String doctorId;
  final String notificationId;

  const DeleteNotification({
    required this.doctorId,
    required this.notificationId,
  });

  @override
  List<Object?> get props => [doctorId, notificationId];
}

/// Clear all notifications.
class ClearAllNotifications extends NotificationHistoryEvent {
  final String doctorId;
  const ClearAllNotifications({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}
