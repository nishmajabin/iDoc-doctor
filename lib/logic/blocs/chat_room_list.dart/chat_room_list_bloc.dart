import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/chat_room_model.dart';
import 'package:idoc_doctor_side/data/repositories/chat_repository.dart';

// ── Events ───────────────────────────────────────────────────────────────────

abstract class ChatRoomListEvent extends Equatable {
  const ChatRoomListEvent();
  @override
  List<Object?> get props => [];
}

class WatchDoctorChatRooms extends ChatRoomListEvent {
  final String doctorId;
  const WatchDoctorChatRooms(this.doctorId);
  @override
  List<Object?> get props => [doctorId];
}

class _ChatRoomsUpdated extends ChatRoomListEvent {
  final List<ChatRoomModel> rooms;
  const _ChatRoomsUpdated(this.rooms);
  @override
  List<Object?> get props => [rooms];
}

class _ChatRoomsError extends ChatRoomListEvent {
  final String message;
  const _ChatRoomsError(this.message);
  @override
  List<Object?> get props => [message];
}

class DisposeChatRoomList extends ChatRoomListEvent {
  const DisposeChatRoomList();
}

// ── States ───────────────────────────────────────────────────────────────────

abstract class ChatRoomListState extends Equatable {
  const ChatRoomListState();
  @override
  List<Object?> get props => [];
}

class ChatRoomListInitial extends ChatRoomListState {
  const ChatRoomListInitial();
}

class ChatRoomListLoading extends ChatRoomListState {
  const ChatRoomListLoading();
}

class ChatRoomListLoaded extends ChatRoomListState {
  final List<ChatRoomModel> rooms;
  const ChatRoomListLoaded(this.rooms);
  @override
  List<Object?> get props => [rooms];
}

class ChatRoomListError extends ChatRoomListState {
  final String message;
  const ChatRoomListError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── BLoC ─────────────────────────────────────────────────────────────────────

class ChatRoomListBloc extends Bloc<ChatRoomListEvent, ChatRoomListState> {
  final ChatRepository _repository;
  StreamSubscription<List<ChatRoomModel>>? _subscription;

  ChatRoomListBloc({ChatRepository? repository})
      : _repository = repository ?? ChatRepository(),
        super(const ChatRoomListInitial()) {
    on<WatchDoctorChatRooms>(_onWatch);
    on<_ChatRoomsUpdated>(_onUpdated);
    on<_ChatRoomsError>(_onError);
    on<DisposeChatRoomList>(_onDispose);
  }

  Future<void> _onWatch(
    WatchDoctorChatRooms event,
    Emitter<ChatRoomListState> emit,
  ) async {
    emit(const ChatRoomListLoading());

    // Cancel any previous subscription before starting a new one
    await _subscription?.cancel();
    _subscription = null;

    // KEY FIX: Use emit.forEach to bind the stream directly to the emitter.
    // This keeps the handler alive for the lifetime of the stream and guarantees
    // emit is never called after the handler completes — which was the crash.
    await emit.forEach<List<ChatRoomModel>>(
      _repository.watchDoctorChatRooms(event.doctorId),
      onData: (rooms) => ChatRoomListLoaded(rooms),
      onError: (error, _) => ChatRoomListError('Stream error: ${error.toString()}'),
    );
  }

  void _onUpdated(
    _ChatRoomsUpdated event,
    Emitter<ChatRoomListState> emit,
  ) {
    emit(ChatRoomListLoaded(event.rooms));
  }

  void _onError(
    _ChatRoomsError event,
    Emitter<ChatRoomListState> emit,
  ) {
    emit(ChatRoomListError(event.message));
  }

  Future<void> _onDispose(
    DisposeChatRoomList event,
    Emitter<ChatRoomListState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = null;
    emit(const ChatRoomListInitial());
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}