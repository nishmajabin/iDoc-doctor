import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/repositories/doctor_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class DoctorAuthBloc extends Bloc<DoctorAuthEvent, DoctorAuthState> {
  final DoctorRepository _repository = DoctorRepository();

  DoctorAuthBloc() : super(DoctorAuthInitial()) {
    on<DoctorLoginRequested>(_onLoginRequested);
    on<DoctorLogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    DoctorLoginRequested event,
    Emitter<DoctorAuthState> emit,
  ) async {
    emit(DoctorAuthLoading());
    
    try {
      final doctor = await _repository.loginDoctor(
        email: event.email,
        password: event.password,
      );
      
      emit(DoctorAuthSuccess(doctor));
    } on DoctorBlockedException catch (e) {
      // Handle blocked doctor separately with special error
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
      emit(DoctorAuthInitial());
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
          emit(DoctorAuthInitial());
        }
      } else {
        emit(DoctorAuthInitial());
      }
    } catch (e) {
      emit(DoctorAuthInitial());
    }
  }

  String _extractErrorMessage(String error) {
    // Extract the actual error message from "Exception: message"
    if (error.startsWith('Exception:')) {
      return error.substring('Exception:'.length).trim();
    }
    return error;
  }
}