import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/exceptions/doctor_exceptions.dart';
import 'package:idoc_doctor_side/core/data/repositories/doctor_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class DoctorAuthBloc extends Bloc<DoctorAuthEvent, DoctorAuthState> {
  final DoctorRepository _repository;

  DoctorAuthBloc({DoctorRepository? repository})
      : _repository = repository ?? DoctorRepository(),
        super(const DoctorAuthInitial()) {
    on<DoctorLoginRequested>(_onLoginRequested);
    on<DoctorLogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);

    // Auto-check on construction
    add(const CheckAuthStatus());
  }

  // ── Handlers ────────────────────────────────────────────────────────────────

  Future<void> _onLoginRequested(
    DoctorLoginRequested event,
    Emitter<DoctorAuthState> emit,
  ) async {
    emit(const DoctorAuthLoading());
    try {
      final doctor = await _repository.loginDoctor(
        email: event.email,
        password: event.password,
      );
      emit(DoctorAuthSuccess(doctor));
    } on DoctorBlockedException catch (e) {
      emit(DoctorAuthBlocked(e.toString()));
    } catch (e) {
      emit(DoctorAuthFailure(_extractErrorMessage(e.toString())));
    }
  }

  Future<void> _onLogoutRequested(
    DoctorLogoutRequested event,
    Emitter<DoctorAuthState> emit,
  ) async {
    try {
      await _repository.logoutDoctor();
      emit(const DoctorAuthInitial());
    } catch (e) {
      emit(DoctorAuthFailure('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<DoctorAuthState> emit,
  ) async {
    try {
      if (_repository.isLoggedIn()) {
        final doctor = await _repository.getCurrentDoctor();
        if (doctor != null) {
          emit(DoctorAuthSuccess(doctor));
        } else {
          emit(const DoctorAuthInitial());
        }
      } else {
        emit(const DoctorAuthInitial());
      }
    } catch (e) {
      emit(const DoctorAuthInitial());
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _extractErrorMessage(String error) {
    if (error.startsWith('Exception:')) {
      return error.substring('Exception:'.length).trim();
    }
    return error;
  }
}