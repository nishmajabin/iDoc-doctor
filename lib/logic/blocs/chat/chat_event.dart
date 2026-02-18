import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Initialize the chat room for an appointment. Must be dispatched first.
class InitializeChatRoom extends ChatEvent {
  final String doctorId;
  final String patientId;
  final String appointmentId;
  final String currentUserId;
  final bool currentUserIsDoctor;
  final String? doctorName;
  final String? patientName;
  final String? doctorProfileImageUrl;
  final String? patientProfileImageUrl;

  const InitializeChatRoom({
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
    required this.currentUserId,
    required this.currentUserIsDoctor,
    this.doctorName,
    this.patientName,
    this.doctorProfileImageUrl,
    this.patientProfileImageUrl,
  });

  @override
  List<Object?> get props => [
        doctorId,
        patientId,
        appointmentId,
        currentUserId,
        currentUserIsDoctor,
      ];
}

/// Send a new text message.
class SendMessage extends ChatEvent {
  final String messageText;

  const SendMessage(this.messageText);

  @override
  List<Object?> get props => [messageText];
}

/// Mark all messages from the other party as read.
class MarkMessagesRead extends ChatEvent {
  const MarkMessagesRead();
}

/// Dispose the chat room (called on screen exit).
class DisposeChatRoom extends ChatEvent {
  const DisposeChatRoom();
}