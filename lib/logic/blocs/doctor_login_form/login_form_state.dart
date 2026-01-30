class DoctorLoginFormState {
  final String email;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool obscurePassword;

  DoctorLoginFormState({
    this.email = '',
    this.password = '',
    this.isEmailValid = true,
    this.isPasswordValid = true,
    this.obscurePassword = true,
  });

  DoctorLoginFormState copyWith({
    String? email,
    String? password,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? obscurePassword,
  }) {
    return DoctorLoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      obscurePassword: obscurePassword ?? this.obscurePassword,
    );
  }
}