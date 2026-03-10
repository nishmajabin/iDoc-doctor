import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/data/services/notification_storage_service.dart';

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
      // Use emit.forEach to keep a live Firestore subscription alive for the
      // duration of this bloc's lifetime. The stream automatically re-emits
      // whenever Firestore data changes (new notification, read/unread toggle,
      // delete, etc.), so the UI always reflects the latest state without any
      // manual refresh logic.
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

  /// Marks a single notification as read. The Firestore write triggers the
  /// [watchNotifications] stream to re-emit, so the UI updates automatically.
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