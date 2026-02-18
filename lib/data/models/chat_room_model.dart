import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ChatRoomModel extends Equatable {
  final String chatRoomId;
  final String doctorId;
  final String patientId;
  final String appointmentId;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final String? lastMessageSenderId;
  final int unreadCountDoctor;
  final int unreadCountPatient;
  final String? doctorName;
  final String? patientName;
  final String? doctorProfileImageUrl;
  final String? patientProfileImageUrl;
  final DateTime createdAt;

  const ChatRoomModel({
    required this.chatRoomId,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSenderId,
    this.unreadCountDoctor = 0,
    this.unreadCountPatient = 0,
    this.doctorName,
    this.patientName,
    this.doctorProfileImageUrl,
    this.patientProfileImageUrl,
    required this.createdAt,
  });

  factory ChatRoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatRoomModel(
      chatRoomId: doc.id,
      doctorId: data['doctorId'] as String? ?? '',
      patientId: data['patientId'] as String? ?? '',
      appointmentId: data['appointmentId'] as String? ?? '',
      lastMessage: data['lastMessage'] as String?,
      lastMessageTime: data['lastMessageTime'] != null
          ? (data['lastMessageTime'] as Timestamp).toDate()
          : null,
      lastMessageSenderId: data['lastMessageSenderId'] as String?,
      unreadCountDoctor: data['unreadCountDoctor'] as int? ?? 0,
      unreadCountPatient: data['unreadCountPatient'] as int? ?? 0,
      doctorName: data['doctorName'] as String?,
      patientName: data['patientName'] as String?,
      doctorProfileImageUrl: data['doctorProfileImageUrl'] as String?,
      patientProfileImageUrl: data['patientProfileImageUrl'] as String?,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'appointmentId': appointmentId,
      'lastMessage': lastMessage,
      'lastMessageTime':
          lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
      'lastMessageSenderId': lastMessageSenderId,
      'unreadCountDoctor': unreadCountDoctor,
      'unreadCountPatient': unreadCountPatient,
      'doctorName': doctorName,
      'patientName': patientName,
      'doctorProfileImageUrl': doctorProfileImageUrl,
      'patientProfileImageUrl': patientProfileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ChatRoomModel copyWith({
    String? chatRoomId,
    String? doctorId,
    String? patientId,
    String? appointmentId,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? lastMessageSenderId,
    int? unreadCountDoctor,
    int? unreadCountPatient,
    String? doctorName,
    String? patientName,
    String? doctorProfileImageUrl,
    String? patientProfileImageUrl,
    DateTime? createdAt,
  }) {
    return ChatRoomModel(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      appointmentId: appointmentId ?? this.appointmentId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      unreadCountDoctor: unreadCountDoctor ?? this.unreadCountDoctor,
      unreadCountPatient: unreadCountPatient ?? this.unreadCountPatient,
      doctorName: doctorName ?? this.doctorName,
      patientName: patientName ?? this.patientName,
      doctorProfileImageUrl:
          doctorProfileImageUrl ?? this.doctorProfileImageUrl,
      patientProfileImageUrl:
          patientProfileImageUrl ?? this.patientProfileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        chatRoomId,
        doctorId,
        patientId,
        appointmentId,
        lastMessage,
        lastMessageTime,
        lastMessageSenderId,
        unreadCountDoctor,
        unreadCountPatient,
        createdAt,
      ];
}