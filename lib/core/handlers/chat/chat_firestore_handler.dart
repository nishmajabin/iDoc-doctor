import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';

class ChatFirestoreHandler {
  ChatFirestoreHandler({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _chatRooms =>
      _firestore.collection('chatRooms');

  CollectionReference<Map<String, dynamic>> _messages(String chatRoomId) =>
      _chatRooms.doc(chatRoomId).collection('messages');

  // ── Chat room ─────────────────────────────────────────────────────────────

  Future<ChatRoomModel?> getChatRoom(String chatRoomId) async {
    final doc = await _chatRooms.doc(chatRoomId).get();
    return doc.exists ? ChatRoomModel.fromFirestore(doc) : null;
  }

  Future<void> createChatRoom(String chatRoomId, ChatRoomModel room) =>
      _chatRooms.doc(chatRoomId).set(room.toFirestore(), SetOptions(merge: true));

  Stream<ChatRoomModel?> watchChatRoom(String chatRoomId) =>
      _chatRooms.doc(chatRoomId).snapshots().map(
            (doc) => doc.exists ? ChatRoomModel.fromFirestore(doc) : null,
          );

  Stream<List<ChatRoomModel>> watchDoctorChatRooms(String doctorId) =>
      _chatRooms.where('doctorId', isEqualTo: doctorId).snapshots().map((snap) {
        final rooms = snap.docs.map(ChatRoomModel.fromFirestore).toList();
        rooms.sort((a, b) {
          if (a.lastMessageTime == null && b.lastMessageTime == null) return 0;
          if (a.lastMessageTime == null) return 1;
          if (b.lastMessageTime == null) return -1;
          return b.lastMessageTime!.compareTo(a.lastMessageTime!);
        });
        return rooms;
      });

  // ── Messages ──────────────────────────────────────────────────────────────

  Stream<List<ChatMessageModel>> watchMessages(String chatRoomId) =>
      _messages(chatRoomId)
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snap) => snap.docs.map(ChatMessageModel.fromFirestore).toList());

  Future<List<ChatMessageModel>> fetchMessages(String chatRoomId) async {
    final snap = await _messages(chatRoomId)
        .orderBy('timestamp', descending: false)
        .get();
    return snap.docs.map(ChatMessageModel.fromFirestore).toList();
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required ChatMessageModel message,
    required bool senderIsDoctor,
  }) async {
    final batch = _firestore.batch();
    final messageRef = _messages(chatRoomId).doc();
    final unreadField = senderIsDoctor ? 'unreadCountPatient' : 'unreadCountDoctor';

    batch.set(messageRef, message.toFirestore());
    batch.update(_chatRooms.doc(chatRoomId), {
      'lastMessage': message.messageText,
      'lastMessageTime': Timestamp.fromDate(message.timestamp),
      'lastMessageSenderId': message.senderId,
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
      final snap = await _messages(chatRoomId)
          .where('isRead', isEqualTo: false)
          .where('receiverId', isEqualTo: currentUserId)
          .get();

      if (snap.docs.isEmpty) return;

      const batchSize = 500;
      for (int i = 0; i < snap.docs.length; i += batchSize) {
        final batch = _firestore.batch();
        final end = (i + batchSize).clamp(0, snap.docs.length);
        for (int j = i; j < end; j++) {
          batch.update(snap.docs[j].reference, {'isRead': true});
        }
        await batch.commit();
      }

      final unreadField = currentUserIsDoctor ? 'unreadCountDoctor' : 'unreadCountPatient';
      await _chatRooms.doc(chatRoomId).update({unreadField: 0});
    } catch (_) {}
  }
}