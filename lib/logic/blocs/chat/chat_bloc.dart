import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/core/data/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repository;

  String? _chatRoomId;
  String? _currentUserId;
  bool _currentUserIsDoctor = false;

  ChatBloc({ChatRepository? repository})
      : _repository = repository ?? ChatRepository(),
        super(const ChatInitial()) {
    on<InitializeChatRoom>(_onInitializeChatRoom);
    on<SendMessage>(_onSendMessage);
    on<MarkMessagesRead>(_onMarkMessagesRead);
    on<DisposeChatRoom>(_onDisposeChatRoom);
  }

  // ── Handlers ──────────────────────────────────────────────────────────────

  Future<void> _onInitializeChatRoom(
    InitializeChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());

    try {
      final chatRoom = await _repository.getOrCreateChatRoom(
        doctorId: event.doctorId,
        patientId: event.patientId,
        appointmentId: event.appointmentId,
        doctorName: event.doctorName,
        patientName: event.patientName,
        doctorProfileImageUrl: event.doctorProfileImageUrl,
        patientProfileImageUrl: event.patientProfileImageUrl,
      );

      // Cache for use in subsequent events.
      _chatRoomId = chatRoom.chatRoomId;
      _currentUserId = event.currentUserId;
      _currentUserIsDoctor = event.currentUserIsDoctor;

      await _repository.markMessagesAsRead(
        chatRoomId: _chatRoomId!,
        currentUserId: _currentUserId!,
        currentUserIsDoctor: _currentUserIsDoctor,
      );

      // Bind the stream to the emitter. The handler (and stream) are cancelled
      // automatically when the BLoC closes.
      await emit.forEach<List<ChatMessageModel>>(
        _repository.watchMessages(_chatRoomId!),
        onData: (messages) {
          final current = state;
          if (current is ChatLoaded) {
            return current.copyWith(messages: messages, isSending: false);
          }
          return ChatLoaded(
            chatRoom: chatRoom,
            messages: messages,
            currentUserId: event.currentUserId,
            currentUserIsDoctor: event.currentUserIsDoctor,
          );
        },
        onError: (_, __) {
          // Preserve the loaded state if we already have data; otherwise error.
          final current = state;
          return current is ChatLoaded
              ? current
              : const ChatError('Stream connection lost. Please retry.');
        },
      );
    } catch (e) {
      emit(ChatError('Failed to initialize chat: ${e.toString()}'));
    }
  }

  /// Sends a text message and manages the isSending optimistic flag.
  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final trimmed = event.messageText.trim();
    if (trimmed.isEmpty) return;

    final current = state;
    if (current is! ChatLoaded || _chatRoomId == null) return;

    emit(current.copyWith(isSending: true));

    try {
      await _repository.sendMessage(
        chatRoomId: _chatRoomId!,
        senderId: _currentUserId!,
        receiverId: _currentUserIsDoctor
            ? current.chatRoom.patientId
            : current.chatRoom.doctorId,
        messageText: trimmed,
        senderIsDoctor: _currentUserIsDoctor,
      );
      // isSending is cleared by the next stream snapshot in _onInitializeChatRoom.
    } catch (_) {
      // Roll back the sending flag on failure.
      final afterError = state;
      emit(
        afterError is ChatLoaded
            ? afterError.copyWith(isSending: false)
            : current.copyWith(isSending: false),
      );
    }
  }

  /// Marks all messages from the other party as read.
  Future<void> _onMarkMessagesRead(
    MarkMessagesRead event,
    Emitter<ChatState> emit,
  ) async {
    if (_chatRoomId == null || _currentUserId == null) return;

    await _repository.markMessagesAsRead(
      chatRoomId: _chatRoomId!,
      currentUserId: _currentUserId!,
      currentUserIsDoctor: _currentUserIsDoctor,
    );
  }

  /// Resets session-scoped state and returns the BLoC to ChatInitial.
  Future<void> _onDisposeChatRoom(
    DisposeChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    _chatRoomId = null;
    _currentUserId = null;
    _currentUserIsDoctor = false;
    emit(const ChatInitial());
  }
}