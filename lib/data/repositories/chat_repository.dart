import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/data/models/chat_room_model.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Chat Room ID generation ─────────────────────────────────────────────────

  String generateChatRoomId({
    required String doctorId,
    required String patientId,
    required String appointmentId,
  }) {
    return '${doctorId}_${patientId}_$appointmentId';
  }

  // ── Chat Room Operations ────────────────────────────────────────────────────

  Future<ChatRoomModel> getOrCreateChatRoom({
    required String doctorId,
    required String patientId,
    required String appointmentId,
    String? doctorName,
    String? patientName,
    String? doctorProfileImageUrl,
    String? patientProfileImageUrl,
  }) async {
    final chatRoomId = generateChatRoomId(
      doctorId: doctorId,
      patientId: patientId,
      appointmentId: appointmentId,
    );

    final docRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      return ChatRoomModel.fromFirestore(snapshot);
    }

    final newRoom = ChatRoomModel(
      chatRoomId: chatRoomId,
      doctorId: doctorId,
      patientId: patientId,
      appointmentId: appointmentId,
      doctorName: doctorName,
      patientName: patientName,
      doctorProfileImageUrl: doctorProfileImageUrl,
      patientProfileImageUrl: patientProfileImageUrl,
      createdAt: DateTime.now(),
    );

    await docRef.set(newRoom.toFirestore(), SetOptions(merge: true));
    return newRoom;
  }

  Stream<ChatRoomModel?> watchChatRoom(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .snapshots()
        .map((doc) => doc.exists ? ChatRoomModel.fromFirestore(doc) : null);
  }

  /// No composite index needed — only filters by doctorId (single field index).
  /// Sorting by lastMessageTime is done client-side after the snapshot arrives.
  Stream<List<ChatRoomModel>> watchDoctorChatRooms(String doctorId) {
    return _firestore
        .collection('chatRooms')
        .where('doctorId', isEqualTo: doctorId) // single-field → no index needed
        .snapshots()
        .map((snap) {
      final rooms = snap.docs
          .map((doc) => ChatRoomModel.fromFirestore(doc))
          .toList();

      // Sort client-side: rooms with no messages go to the bottom
      rooms.sort((a, b) {
        if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
        if (a.lastMessageTime == null) return 1;
        if (b.lastMessageTime == null) return -1;
        return b.lastMessageTime!.compareTo(a.lastMessageTime!); // descending
      });

      return rooms;
    });
  }

  // ── Message Operations ──────────────────────────────────────────────────────

  /// Single-field orderBy on timestamp — no composite index needed.
  Stream<List<ChatMessageModel>> watchMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ChatMessageModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String messageText,
    required bool senderIsDoctor,
  }) async {
    final batch = _firestore.batch();

    final messageRef = _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc();

    final message = ChatMessageModel(
      messageId: messageRef.id,
      senderId: senderId,
      receiverId: receiverId,
      messageText: messageText.trim(),
      timestamp: DateTime.now(),
      isRead: false,
    );

    batch.set(messageRef, message.toFirestore());

    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final unreadField =
        senderIsDoctor ? 'unreadCountPatient' : 'unreadCountDoctor';

    batch.update(chatRoomRef, {
      'lastMessage': messageText.trim(),
      'lastMessageTime': Timestamp.fromDate(message.timestamp),
      'lastMessageSenderId': senderId,
      unreadField: FieldValue.increment(1),
    });

    await batch.commit();
  }

  Future<void> markMessagesAsRead({
    required String chatRoomId,
    required String currentUserId,
    required bool currentUserIsDoctor,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('receiverId', isEqualTo: currentUserId)
          .get();

      if (snapshot.docs.isEmpty) return;

      const batchSize = 500;
      for (int i = 0; i < snapshot.docs.length; i += batchSize) {
        final batch = _firestore.batch();
        final end = (i + batchSize < snapshot.docs.length)
            ? i + batchSize
            : snapshot.docs.length;
        for (int j = i; j < end; j++) {
          batch.update(snapshot.docs[j].reference, {'isRead': true});
        }
        await batch.commit();
      }

      final unreadField =
          currentUserIsDoctor ? 'unreadCountDoctor' : 'unreadCountPatient';
      await _firestore.collection('chatRooms').doc(chatRoomId).update({
        unreadField: 0,
      });
    } catch (_) {
      // Non-critical — silently fail
    }
  }

  Future<List<ChatMessageModel>> fetchMessages(String chatRoomId) async {
    final snapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs
        .map((doc) => ChatMessageModel.fromFirestore(doc))
        .toList();
  }
}