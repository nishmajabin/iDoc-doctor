import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';

abstract class DoctorAuthState extends Equatable {
  const DoctorAuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no session determined yet.
class DoctorAuthInitial extends DoctorAuthState {
  const DoctorAuthInitial();
}

/// Auth operation in progress (login / logout / status check).
class DoctorAuthLoading extends DoctorAuthState {
  const DoctorAuthLoading();
}

/// Doctor is authenticated and their profile is loaded.
class DoctorAuthSuccess extends DoctorAuthState {
  final DoctorModel doctor;

  const DoctorAuthSuccess(this.doctor);

  @override
  List<Object?> get props => [doctor.id];
}

/// Authentication failed with a generic error.
class DoctorAuthFailure extends DoctorAuthState {
  final String message;

  const DoctorAuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Doctor account is blocked by admin.
class DoctorAuthBlocked extends DoctorAuthState {
  final String message;

  const DoctorAuthBlocked(this.message);

  @override
  List<Object?> get props => [message];
}