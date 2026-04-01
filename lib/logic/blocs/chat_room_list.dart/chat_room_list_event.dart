import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';

/// Base event class for the ChatRoomList BLoC.
abstract class ChatRoomListEvent extends Equatable {
  const ChatRoomListEvent();

  @override
  List<Object?> get props => [];
}

/// Start watching real-time chat rooms for a doctor.
class WatchDoctorChatRooms extends ChatRoomListEvent {
  final String doctorId;

  const WatchDoctorChatRooms(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

/// Internal event emitted when the stream delivers a new snapshot.
/// Prefixed with underscore convention — not exposed outside the BLoC layer.
class ChatRoomsUpdated extends ChatRoomListEvent {
  final List<ChatRoomModel> rooms;

  const ChatRoomsUpdated(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

/// Internal event emitted when the stream encounters an error.
class ChatRoomsStreamError extends ChatRoomListEvent {
  final String message;

  const ChatRoomsStreamError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Disposes the active stream subscription and resets to initial state.
class DisposeChatRoomList extends ChatRoomListEvent {
  const DisposeChatRoomList();
}