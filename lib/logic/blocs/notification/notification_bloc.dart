import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/repositories/notification_repository.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  NotificationBloc({NotificationRepository? repository})
      : _repository = repository ?? NotificationRepository(),
        super(const NotificationInitial()) {
    on<InitializeNotifications>(_onInitialize);
    on<StartListeningForNotifications>(_onStartListening);
    on<StopNotifications>(_onStop);
  }


  Future<void> _onInitialize(
    InitializeNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    try {
      // Initialize FCM, local notifications, permissions, token.
      await _repository.initialize(event.doctorId);

      // Start Firestore listeners.
      _repository.listenForAppointments(event.doctorId);
      _repository.listenForChatMessages(event.doctorId);

      emit(NotificationReady(doctorId: event.doctorId));
      debugPrint('[NotificationBloc] Initialized for ${event.doctorId}');
    } catch (e) {
      debugPrint('[NotificationBloc] Initialization error: $e');
      emit(NotificationError('Failed to initialize notifications: $e'));
    }
  }


  Future<void> _onStartListening(
    StartListeningForNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      _repository.listenForAppointments(event.doctorId);
      _repository.listenForChatMessages(event.doctorId);

      emit(NotificationReady(doctorId: event.doctorId));
      debugPrint('[NotificationBloc] Listeners started for ${event.doctorId}');
    } catch (e) {
      debugPrint('[NotificationBloc] Start listening error: $e');
      emit(NotificationError('Failed to start notification listeners: $e'));
    }
  }

  /// Stops all listeners, removes the FCM token, and resets state.
  Future<void> _onStop(
    StopNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _repository.removeFcmToken(event.doctorId);
      await _repository.dispose();

      emit(const NotificationStopped());
      debugPrint('[NotificationBloc] Stopped for ${event.doctorId}');
    } catch (e) {
      debugPrint('[NotificationBloc] Stop error: $e');
      emit(NotificationError('Failed to stop notifications: $e'));
    }
  }

  @override
  Future<void> close() async {
    await _repository.dispose();
    return super.close();
  }
}
