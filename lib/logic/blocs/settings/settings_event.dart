import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

class LogoutRequested extends SettingsEvent {
  const LogoutRequested();
}

class NotificationsToggled extends SettingsEvent {
  final bool value;
  const NotificationsToggled(this.value);
  @override
  List<Object?> get props => [value];
}

class AppointmentRemindersToggled extends SettingsEvent {
  final bool value;
  const AppointmentRemindersToggled(this.value);
  @override
  List<Object?> get props => [value];
}

class NewPatientAlertsToggled extends SettingsEvent {
  final bool value;
  const NewPatientAlertsToggled(this.value);
  @override
  List<Object?> get props => [value];
}