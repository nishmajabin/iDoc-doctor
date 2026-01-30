abstract class DoctorAuthEvent {}

class DoctorLoginRequested extends DoctorAuthEvent {
  final String email;
  final String password;

  DoctorLoginRequested({
    required this.email,
    required this.password,
  });
}

class DoctorLogoutRequested extends DoctorAuthEvent {}

class CheckAuthStatus extends DoctorAuthEvent {}