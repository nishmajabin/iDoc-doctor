// // FIXED: SendMessage no longer emits stale state after Firestore write.
// // See _onSendMessage for detailed explanation.
// import 'dart:async';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:idoc_doctor_side/data/models/chat_message_model.dart';
// import 'package:idoc_doctor_side/data/repositories/chat_repository.dart';
// import 'chat_event.dart';
// import 'chat_state.dart';

// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final ChatRepository _repository;

//   String? _chatRoomId;
//   String? _currentUserId;
//   bool _currentUserIsDoctor = false;

//   ChatBloc({ChatRepository? repository})
//       : _repository = repository ?? ChatRepository(),
//         super(const ChatInitial()) {
//     on<InitializeChatRoom>(_onInitializeChatRoom);
//     on<SendMessage>(_onSendMessage);
//     on<MarkMessagesRead>(_onMarkMessagesRead);
//     on<DisposeChatRoom>(_onDisposeChatRoom);
//   }

//   // ── Handlers ────────────────────────────────────────────────────────────────

//   Future<void> _onInitializeChatRoom(
//     InitializeChatRoom event,
//     Emitter<ChatState> emit,
//   ) async {
//     emit(const ChatLoading());
//     try {
//       // Get or create the chat room
//       final chatRoom = await _repository.getOrCreateChatRoom(
//         doctorId: event.doctorId,
//         patientId: event.patientId,
//         appointmentId: event.appointmentId,
//         doctorName: event.doctorName,
//         patientName: event.patientName,
//         doctorProfileImageUrl: event.doctorProfileImageUrl,
//         patientProfileImageUrl: event.patientProfileImageUrl,
//       );

//       // Cache for subsequent events
//       _chatRoomId = chatRoom.chatRoomId;
//       _currentUserId = event.currentUserId;
//       _currentUserIsDoctor = event.currentUserIsDoctor;

//       // ✅ FIX for Issue 1: Mark as read ONCE when screen opens
//       await _repository.markMessagesAsRead(
//         chatRoomId: _chatRoomId!,
//         currentUserId: _currentUserId!,
//         currentUserIsDoctor: _currentUserIsDoctor,
//       );

//       await emit.forEach<List<ChatMessageModel>>(
//         _repository.watchMessages(_chatRoomId!),
//         onData: (messages) {
//           // ✅ FIX: Do NOT mark as read here — only on screen open above
//           // This prevents the badge from disappearing when doctor sends
//           // a message while still on the chat list screen

//           final current = state;
//           if (current is ChatLoaded) {
//             return current.copyWith(messages: messages, isSending: false);
//           }

//           // First emission — build the initial loaded state
//           return ChatLoaded(
//             chatRoom: chatRoom,
//             messages: messages,
//             currentUserId: event.currentUserId,
//             currentUserIsDoctor: event.currentUserIsDoctor,
//           );
//         },
//         onError: (_, __) {
//           final current = state;
//           if (current is ChatLoaded) return current;
//           return const ChatError('Stream connection lost. Please retry.');
//         },
//       );

//     } catch (e) {
//       emit(ChatError('Failed to initialize chat: ${e.toString()}'));
//     }
//   }

//   Future<void> _onSendMessage(
//     SendMessage event,
//     Emitter<ChatState> emit,
//   ) async {
//     final trimmed = event.messageText.trim();
//     if (trimmed.isEmpty) return;

//     final current = state;
//     if (current is! ChatLoaded || _chatRoomId == null) return;

//     // Show spinner while the write is in-flight
//     emit(current.copyWith(isSending: true));

//     try {
//       await _repository.sendMessage(
//         chatRoomId: _chatRoomId!,
//         senderId: _currentUserId!,
//         receiverId: _currentUserIsDoctor
//             ? current.chatRoom.patientId
//             : current.chatRoom.doctorId,
//         messageText: trimmed,
//         senderIsDoctor: _currentUserIsDoctor,
//       );

//       // ✅ THE FIX — emit NOTHING on success.
//       //
//       // By the time sendMessage() returns, the Firestore stream's onData
//       // has already fired and updated `state` with the new message AND
//       // reset isSending → false (see emit.forEach above).
//       //
//       // If we emitted `current.copyWith(isSending: false)` here we would
//       // overwrite that fresh state with the stale pre-send messages list,
//       // making the new message vanish — exactly the reported bug.
//     } catch (e) {
//       // On error: read state freshly — the stream may have updated it
//       // while the write was in-flight.
//       final afterError = state;
//       if (afterError is ChatLoaded) {
//         emit(afterError.copyWith(isSending: false));
//       } else {
//         emit(current.copyWith(isSending: false));
//       }
//     }
//   }

//   Future<void> _onMarkMessagesRead(
//     MarkMessagesRead event,
//     Emitter<ChatState> emit,
//   ) async {
//     if (_chatRoomId == null || _currentUserId == null) return;
//     await _repository.markMessagesAsRead(
//       chatRoomId: _chatRoomId!,
//       currentUserId: _currentUserId!,
//       currentUserIsDoctor: _currentUserIsDoctor,
//     );
//   }

//   Future<void> _onDisposeChatRoom(
//     DisposeChatRoom event,
//     Emitter<ChatState> emit,
//   ) async {
//     _chatRoomId = null;
//     _currentUserId = null;
//     emit(const ChatInitial());
//   }
// }
// FIXED: SendMessage no longer emits stale state after Firestore write.
// See _onSendMessage for detailed explanation.
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/data/repositories/chat_repository.dart';
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

  // ── Handlers ────────────────────────────────────────────────────────────────

  Future<void> _onInitializeChatRoom(
    InitializeChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    try {
      // Get or create the chat room
      final chatRoom = await _repository.getOrCreateChatRoom(
        doctorId: event.doctorId,
        patientId: event.patientId,
        appointmentId: event.appointmentId,
        doctorName: event.doctorName,
        patientName: event.patientName,
        doctorProfileImageUrl: event.doctorProfileImageUrl,
        patientProfileImageUrl: event.patientProfileImageUrl,
      );

      // Cache for subsequent events
      _chatRoomId = chatRoom.chatRoomId;
      _currentUserId = event.currentUserId;
      _currentUserIsDoctor = event.currentUserIsDoctor;

      // ✅ FIX for Issue 1: Mark as read ONCE when screen opens
      await _repository.markMessagesAsRead(
        chatRoomId: _chatRoomId!,
        currentUserId: _currentUserId!,
        currentUserIsDoctor: _currentUserIsDoctor,
      );

      await emit.forEach<List<ChatMessageModel>>(
        _repository.watchMessages(_chatRoomId!),
        onData: (messages) {
          // ✅ FIX: Do NOT mark as read here — only on screen open above
          // This prevents the badge from disappearing when doctor sends
          // a message while still on the chat list screen

          final current = state;
          if (current is ChatLoaded) {
            return current.copyWith(messages: messages, isSending: false);
          }

          // First emission — build the initial loaded state
          return ChatLoaded(
            chatRoom: chatRoom,
            messages: messages,
            currentUserId: event.currentUserId,
            currentUserIsDoctor: event.currentUserIsDoctor,
          );
        },
        onError: (_, __) {
          final current = state;
          if (current is ChatLoaded) return current;
          return const ChatError('Stream connection lost. Please retry.');
        },
      );

    } catch (e) {
      emit(ChatError('Failed to initialize chat: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    final trimmed = event.messageText.trim();
    if (trimmed.isEmpty) return;

    final current = state;
    if (current is! ChatLoaded || _chatRoomId == null) return;

    // Show spinner while the write is in-flight
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

      // ✅ THE FIX — emit NOTHING on success.
      //
      // By the time sendMessage() returns, the Firestore stream's onData
      // has already fired and updated `state` with the new message AND
      // reset isSending → false (see emit.forEach above).
      //
      // If we emitted `current.copyWith(isSending: false)` here we would
      // overwrite that fresh state with the stale pre-send messages list,
      // making the new message vanish — exactly the reported bug.
    } catch (e) {
      // On error: read state freshly — the stream may have updated it
      // while the write was in-flight.
      final afterError = state;
      if (afterError is ChatLoaded) {
        emit(afterError.copyWith(isSending: false));
      } else {
        emit(current.copyWith(isSending: false));
      }
    }
  }

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

  Future<void> _onDisposeChatRoom(
    DisposeChatRoom event,
    Emitter<ChatState> emit,
  ) async {
    _chatRoomId = null;
    _currentUserId = null;
    emit(const ChatInitial());
  }
}