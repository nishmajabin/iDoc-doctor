import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/core/data/services/notification_storage_service.dart';

import 'notification_history_event.dart';
import 'notification_history_state.dart';

class NotificationHistoryBloc
    extends Bloc<NotificationHistoryEvent, NotificationHistoryState> {
  final NotificationStorageService _storage;

  NotificationHistoryBloc({NotificationStorageService? storageService})
      : _storage = storageService ?? NotificationStorageService(),
        super(const NotificationHistoryInitial()) {
    on<LoadNotificationHistory>(_onLoad);
    on<MarkNotificationRead>(_onMarkRead);
    on<MarkAllNotificationsRead>(_onMarkAllRead);
    on<DeleteNotification>(_onDelete);
    on<ClearAllNotifications>(_onClearAll);
  }

  // ── Load / Watch ──────────────────────────────────────────────────────────

  Future<void> _onLoad(
    LoadNotificationHistory event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    emit(const NotificationHistoryLoading());

    try {
      await emit.forEach<List<NotificationItemModel>>(
        _storage.watchNotifications(event.doctorId),
        onData: (notifications) {
          final unreadCount = notifications.where((n) => !n.isRead).length;
          return NotificationHistoryLoaded(
            notifications: notifications,
            unreadCount: unreadCount,
          );
        },
        onError: (error, stackTrace) {
          debugPrint('[NotifHistoryBloc] Stream error: $error\n$stackTrace');
          return NotificationHistoryError(error.toString());
        },
      );
    } catch (e) {
      debugPrint('[NotifHistoryBloc] Load error: $e');
      emit(NotificationHistoryError(e.toString()));
    }
  }

  // ── Mark Read ─────────────────────────────────────────────────────────────

  Future<void> _onMarkRead(
    MarkNotificationRead event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    try {
      await _storage.markAsRead(event.doctorId, event.notificationId);
    } catch (e) {
      debugPrint('[NotifHistoryBloc] Mark read error: $e');
    }
  }

  // ── Mark All Read ─────────────────────────────────────────────────────────

  Future<void> _onMarkAllRead(
    MarkAllNotificationsRead event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    try {
      await _storage.markAllAsRead(event.doctorId);
    } catch (e) {
      debugPrint('[NotifHistoryBloc] Mark all read error: $e');
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> _onDelete(
    DeleteNotification event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    try {
      await _storage.deleteNotification(event.doctorId, event.notificationId);
    } catch (e) {
      debugPrint('[NotifHistoryBloc] Delete error: $e');
    }
  }

  // ── Clear All ─────────────────────────────────────────────────────────────

  Future<void> _onClearAll(
    ClearAllNotifications event,
    Emitter<NotificationHistoryState> emit,
  ) async {
    try {
      await _storage.clearAll(event.doctorId);
    } catch (e) {
      debugPrint('[NotifHistoryBloc] Clear all error: $e');
    }
  }
}