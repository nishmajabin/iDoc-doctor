import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/core/data/services/notification_service.dart';

class NotificationChatHandler {
  NotificationChatHandler({
    required FirebaseFirestore firestore,
    required NotificationService notificationService,
    required void Function({
      required String title,
      required String body,
      required NotificationType type,
      Map<String, dynamic>? data,
      String? notificationId,
    })
    onPersist,
  }) : _firestore = firestore,
       _notificationService = notificationService,
       _onPersist = onPersist;

  final FirebaseFirestore _firestore;
  final NotificationService _notificationService;
  final void Function({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
    String? notificationId,
  })
  _onPersist;

  final Map<String, DateTime> _lastSeenMessageTime = {};
  StreamSubscription<QuerySnapshot>? _chatRoomSub;
  final List<StreamSubscription> _chatMessageSubs = [];

  // ── Public ────────────────────────────────────────────────────────────────

  void listen(String doctorId) {
    _chatRoomSub?.cancel();
    for (final sub in _chatMessageSubs) {
      sub.cancel();
    }
    _chatMessageSubs.clear();

    _chatRoomSub = _firestore
        .collection('chatRooms')
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .listen(
          (snapshot) {
            for (final doc in snapshot.docs) {
              _watchMessages(doc.id, doctorId);
            }
          },
          onError: (e) {
            debugPrint('[ChatHandler] Chat room listener error: $e');
          },
        );
  }

  void dispose() {
    _chatRoomSub?.cancel();
    for (final sub in _chatMessageSubs) {
      sub.cancel();
    }
    _chatMessageSubs.clear();
    _lastSeenMessageTime.clear();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  void _watchMessages(String chatRoomId, String doctorId) {
    final sub = _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.docs.isEmpty) return;

            final data = snapshot.docs.first.data();
            final senderId = data['senderId'] as String? ?? '';
            final messageText = data['messageText'] as String? ?? '';
            final timestamp =
                data['timestamp'] != null
                    ? (data['timestamp'] as Timestamp).toDate()
                    : DateTime.now();

            if (senderId == doctorId) return;

            final lastSeen = _lastSeenMessageTime[chatRoomId];
            if (lastSeen != null && !timestamp.isAfter(lastSeen)) return;

            _lastSeenMessageTime[chatRoomId] = timestamp;
            if (lastSeen == null) return;

            _firestore.collection('chatRooms').doc(chatRoomId).get().then((
              roomDoc,
            ) {
              final patientName =
                  roomDoc.data()?['patientName'] as String? ?? 'A patient';
              final title = '💬 New Message from $patientName';
              final body =
                  messageText.length > 100
                      ? '${messageText.substring(0, 100)}…'
                      : messageText;

              _notificationService.showNotification(
                title: title,
                body: body,
                payload:
                    '{"type":"new_chat_message","chatRoomId":"$chatRoomId"}',
              );

              _onPersist(
                title: title,
                body: body,
                type: NotificationType.chatMessage,
                data: {'chatRoomId': chatRoomId},
              );
            });
          },
          onError: (e) {
            debugPrint('[ChatHandler] Message listener error: $e');
          },
        );

    _chatMessageSubs.add(sub);
  }
}
