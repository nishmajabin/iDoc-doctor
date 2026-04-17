import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:idoc_doctor_side/core/handlers/chat/chat_firestore_handler.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';

class ChatRepository {
  ChatRepository({FirebaseFirestore? firestore})
      : _handler = ChatFirestoreHandler(firestore: firestore);

  final ChatFirestoreHandler _handler;

  // ── Chat room ID ──────────────────────────────────────────────────────────

  String generateChatRoomId({
    required String doctorId,
    required String patientId,
    required String appointmentId,
  }) =>
      '${doctorId}_${patientId}_$appointmentId';

  // ── Chat room ─────────────────────────────────────────────────────────────

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

    final existing = await _handler.getChatRoom(chatRoomId);
    if (existing != null) return existing;

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

    await _handler.createChatRoom(chatRoomId, newRoom);
    return newRoom;
  }

  Stream<ChatRoomModel?> watchChatRoom(String chatRoomId) =>
      _handler.watchChatRoom(chatRoomId);

  Stream<List<ChatRoomModel>> watchDoctorChatRooms(String doctorId) =>
      _handler.watchDoctorChatRooms(doctorId);

  // ── Messages ──────────────────────────────────────────────────────────────

  Stream<List<ChatMessageModel>> watchMessages(String chatRoomId) =>
      _handler.watchMessages(chatRoomId);

  Future<List<ChatMessageModel>> fetchMessages(String chatRoomId) =>
      _handler.fetchMessages(chatRoomId);

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String messageText,
    required bool senderIsDoctor,
  }) =>
      _handler.sendMessage(
        chatRoomId: chatRoomId,
        message: ChatMessageModel(
          messageId: '',
          senderId: senderId,
          receiverId: receiverId,
          messageText: messageText.trim(),
          timestamp: DateTime.now(),
          isRead: false,
        ),
        senderIsDoctor: senderIsDoctor,
      );

  Future<void> markMessagesAsRead({
    required String chatRoomId,
    required String currentUserId,
    required bool currentUserIsDoctor,
  }) =>
      _handler.markMessagesAsRead(
        chatRoomId: chatRoomId,
        currentUserId: currentUserId,
        currentUserIsDoctor: currentUserIsDoctor,
      );
}
