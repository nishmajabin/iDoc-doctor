import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/data/models/chat_room_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state — before any event is dispatched.
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Chat room is being set up / messages are loading.
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Chat room is ready and messages are streaming.
class ChatLoaded extends ChatState {
  final ChatRoomModel chatRoom;
  final List<ChatMessageModel> messages;
  final String currentUserId;
  final bool currentUserIsDoctor;
  final bool isSending;

  const ChatLoaded({
    required this.chatRoom,
    required this.messages,
    required this.currentUserId,
    required this.currentUserIsDoctor,
    this.isSending = false,
  });

  ChatLoaded copyWith({
    ChatRoomModel? chatRoom,
    List<ChatMessageModel>? messages,
    String? currentUserId,
    bool? currentUserIsDoctor,
    bool? isSending,
  }) {
    return ChatLoaded(
      chatRoom: chatRoom ?? this.chatRoom,
      messages: messages ?? this.messages,
      currentUserId: currentUserId ?? this.currentUserId,
      currentUserIsDoctor: currentUserIsDoctor ?? this.currentUserIsDoctor,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [
        chatRoom,
        messages,
        currentUserId,
        currentUserIsDoctor,
        isSending,
      ];
}

/// An error occurred.
class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}