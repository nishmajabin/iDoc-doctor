import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';

class NotificationStorageService {
  final FirebaseFirestore _firestore;

  NotificationStorageService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _colRef(String doctorId) =>
      _firestore
          .collection('doctors')
          .doc(doctorId)
          .collection('notifications');

  // ── CREATE ─────────────────────────────────────────────────────────────────

  Future<void> saveNotification(NotificationItemModel notification) async {
    try {
      await _colRef(notification.doctorId)
          .doc(notification.notificationId)
          .set(notification.toFirestore());
      debugPrint(
          '[NotifStorage] Saved: ${notification.notificationId}');
    } catch (e) {
      debugPrint('[NotifStorage] Error saving notification: $e');
    }
  }

  // ── READ ───────────────────────────────────────────────────────────────────

  Stream<List<NotificationItemModel>> watchNotifications(String doctorId) {
    return _colRef(doctorId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) {
      final now = DateTime.now();
      return snap.docs
          .map((doc) => NotificationItemModel.fromFirestore(doc))
          .where((n) => !n.timestamp.isAfter(now))
          .toList();
    });
  }

  /// One-shot fetch. Only returns notifications whose timestamp ≤ now.
  Future<List<NotificationItemModel>> fetchNotifications(
      String doctorId) async {
    final snap = await _colRef(doctorId)
        .orderBy('timestamp', descending: true)
        .get();
    final now = DateTime.now();
    return snap.docs
        .map((doc) => NotificationItemModel.fromFirestore(doc))
        .where((n) => !n.timestamp.isAfter(now))
        .toList();
  }

  /// Count of unread notifications (excluding future-scheduled ones).
  Stream<int> watchUnreadCount(String doctorId) {
    return _colRef(doctorId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snap) {
      final now = DateTime.now();
      return snap.docs
          .map((doc) => NotificationItemModel.fromFirestore(doc))
          .where((n) => !n.timestamp.isAfter(now))
          .length;
    });
  }

  // ── UPDATE ─────────────────────────────────────────────────────────────────

  Future<void> markAsRead(String doctorId, String notificationId) async {
    try {
      await _colRef(doctorId).doc(notificationId).update({'isRead': true});
    } catch (e) {
      debugPrint('[NotifStorage] Error marking read: $e');
    }
  }

  Future<void> markAllAsRead(String doctorId) async {
    try {
      final snap =
          await _colRef(doctorId).where('isRead', isEqualTo: false).get();
      if (snap.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      debugPrint('[NotifStorage] Marked all as read');
    } catch (e) {
      debugPrint('[NotifStorage] Error marking all read: $e');
    }
  }

  // ── DELETE ─────────────────────────────────────────────────────────────────

  Future<void> deleteNotification(String doctorId, String notificationId) async {
    try {
      await _colRef(doctorId).doc(notificationId).delete();
    } catch (e) {
      debugPrint('[NotifStorage] Error deleting: $e');
    }
  }

  Future<void> clearAll(String doctorId) async {
    try {
      final snap = await _colRef(doctorId).get();
      if (snap.docs.isEmpty) return;

      final batch = _firestore.batch();
      for (final doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      debugPrint('[NotifStorage] Cleared all notifications');
    } catch (e) {
      debugPrint('[NotifStorage] Error clearing all: $e');
    }
  }
}
