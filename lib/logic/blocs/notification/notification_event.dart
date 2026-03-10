import 'package:equatable/equatable.dart';

/// Base class for all notification events.
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Initializes the entire notification system.
/// Should be dispatched once after the doctor logs in.
class InitializeNotifications extends NotificationEvent {
  final String doctorId;

  const InitializeNotifications({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

/// Starts listening for Firestore changes (appointments + chats).
class StartListeningForNotifications extends NotificationEvent {
  final String doctorId;

  const StartListeningForNotifications({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}

/// Stops all listeners and cleans up (e.g. on logout).
class StopNotifications extends NotificationEvent {
  final String doctorId;

  const StopNotifications({required this.doctorId});

  @override
  List<Object?> get props => [doctorId];
}
