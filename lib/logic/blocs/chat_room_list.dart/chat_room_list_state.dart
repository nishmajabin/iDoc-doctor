import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';

/// Base state class for the ChatRoomList BLoC.
sealed class ChatRoomListState extends Equatable {
  const ChatRoomListState();

  @override
  List<Object?> get props => [];
}

/// The BLoC has been created but no event has been dispatched yet.
class ChatRoomListInitial extends ChatRoomListState {
  const ChatRoomListInitial();
}

/// A stream subscription has been started; awaiting the first snapshot.
class ChatRoomListLoading extends ChatRoomListState {
  const ChatRoomListLoading();
}

/// The stream delivered a (possibly empty) list of chat rooms.
class ChatRoomListLoaded extends ChatRoomListState {
  final List<ChatRoomModel> rooms;

  const ChatRoomListLoaded(this.rooms);

  /// Convenience getter — avoids scattering `.rooms.isEmpty` checks in the UI.
  bool get isEmpty => rooms.isEmpty;

  @override
  List<Object?> get props => [rooms];
}

/// An unrecoverable error occurred while listening to the stream.
class ChatRoomListError extends ChatRoomListState {
  final String message;

  const ChatRoomListError(this.message);

  @override
  List<Object?> get props => [message];
}