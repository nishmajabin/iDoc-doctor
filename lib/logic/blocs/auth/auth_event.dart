
import 'package:equatable/equatable.dart';

abstract class DoctorAuthEvent extends Equatable {
  const DoctorAuthEvent();

  @override
  List<Object?> get props => [];
}

/// Doctor taps "Sign In" with email + password.
class DoctorLoginRequested extends DoctorAuthEvent {
  final String email;
  final String password;

  const DoctorLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Doctor taps "Sign Out".
class DoctorLogoutRequested extends DoctorAuthEvent {
  const DoctorLogoutRequested();
}

/// Check Firebase Auth persistence on app launch.
class CheckAuthStatus extends DoctorAuthEvent {
  const CheckAuthStatus();
}