import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/repositories/auth_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_event.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final DoctorAuthRepository _authRepository;

  static const _keyNotifications       = 'pref_notifications';
  static const _keyAppointmentReminders = 'pref_appointment_reminders';
  static const _keyNewPatientAlerts    = 'pref_new_patient_alerts';

  SettingsBloc({DoctorAuthRepository? authRepository})
      : _authRepository = authRepository ?? DoctorAuthRepository(),
        super(const SettingsInitial()) {
    on<LoadSettings>(_onLoad);
    on<LogoutRequested>(_onLogout);
    on<NotificationsToggled>(_onNotificationsToggled);
    on<AppointmentRemindersToggled>(_onAppointmentRemindersToggled);
    on<NewPatientAlertsToggled>(_onNewPatientAlertsToggled);
  }

  Future<void> _onLoad(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      emit(SettingsLoaded(
        notificationsEnabled:
            prefs.getBool(_keyNotifications) ?? true,
        appointmentReminders:
            prefs.getBool(_keyAppointmentReminders) ?? true,
        newPatientAlerts:
            prefs.getBool(_keyNewPatientAlerts) ?? false,
      ));
    } catch (_) {
      emit(const SettingsLoaded());
    }
  }

  Future<void> _onLogout(
    LogoutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _authRepository.logoutDoctor();
      emit(const SettingsLogoutSuccess());
    } catch (e) {
      emit(SettingsError(e.toString()));
    }
  }

  Future<void> _onNotificationsToggled(
    NotificationsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoaded) return;
    final current = state as SettingsLoaded;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, event.value);
    emit(current.copyWith(notificationsEnabled: event.value));
  }

  Future<void> _onAppointmentRemindersToggled(
    AppointmentRemindersToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoaded) return;
    final current = state as SettingsLoaded;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAppointmentReminders, event.value);
    emit(current.copyWith(appointmentReminders: event.value));
  }

  Future<void> _onNewPatientAlertsToggled(
    NewPatientAlertsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoaded) return;
    final current = state as SettingsLoaded;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNewPatientAlerts, event.value);
    emit(current.copyWith(newPatientAlerts: event.value));
  }
}