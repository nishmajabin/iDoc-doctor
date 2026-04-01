import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';
import 'package:idoc_doctor_side/core/data/repositories/chat_repository.dart';

import 'chat_room_list_event.dart';
import 'chat_room_list_state.dart';

class ChatRoomListBloc extends Bloc<ChatRoomListEvent, ChatRoomListState> {
  final ChatRepository _repository;

  ChatRoomListBloc({ChatRepository? repository})
      : _repository = repository ?? ChatRepository(),
        super(const ChatRoomListInitial()) {
    on<WatchDoctorChatRooms>(_onWatch);
    on<DisposeChatRoomList>(_onDispose);
  }

  // ── Handlers ──────────────────────────────────────────────────────────────
  Future<void> _onWatch(
    WatchDoctorChatRooms event,
    Emitter<ChatRoomListState> emit,
  ) async {
    emit(const ChatRoomListLoading());

    await emit.forEach<List<ChatRoomModel>>(
      _repository.watchDoctorChatRooms(event.doctorId),
      onData: ChatRoomListLoaded.new,
      onError: (error, _) =>
          ChatRoomListError('Failed to load messages: ${error.toString()}'),
    );
  }

  /// Resets the BLoC to its initial state (e.g. on screen exit).
  Future<void> _onDispose(
    DisposeChatRoomList event,
    Emitter<ChatRoomListState> emit,
  ) async {
    emit(const ChatRoomListInitial());
  }
}