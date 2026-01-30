abstract class DoctorLoginFormEvent {}

class EmailChanged extends DoctorLoginFormEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends DoctorLoginFormEvent {
  final String password;
  PasswordChanged(this.password);
}

class TogglePasswordVisibility extends DoctorLoginFormEvent {}