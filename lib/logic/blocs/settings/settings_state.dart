import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final bool notificationsEnabled;
  final bool appointmentReminders;
  final bool newPatientAlerts;

  const SettingsLoaded({
    this.notificationsEnabled = true,
    this.appointmentReminders = true,
    this.newPatientAlerts = false,
  });

  SettingsLoaded copyWith({
    bool? notificationsEnabled,
    bool? appointmentReminders,
    bool? newPatientAlerts,
  }) {
    return SettingsLoaded(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      newPatientAlerts: newPatientAlerts ?? this.newPatientAlerts,
    );
  }

  @override
  List<Object?> get props =>
      [notificationsEnabled, appointmentReminders, newPatientAlerts];
}

class SettingsLogoutSuccess extends SettingsState {
  const SettingsLogoutSuccess();
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override
  List<Object?> get props => [message];
}