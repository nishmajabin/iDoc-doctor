import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';

/// Base state class for the Chat BLoC.
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// BLoC is freshly created or has been disposed.
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Chat room initialisation is in progress (getOrCreate + first snapshot).
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Chat room is ready and the messages stream is active.
class ChatLoaded extends ChatState {
  final ChatRoomModel chatRoom;
  final List<ChatMessageModel> messages;
  final String currentUserId;
  final bool currentUserIsDoctor;

  /// True while a send-message request is in flight.
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

/// An unrecoverable error occurred during initialisation or streaming.
class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}