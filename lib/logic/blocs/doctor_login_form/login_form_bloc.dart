import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_form_event.dart';
import 'login_form_state.dart';

class DoctorLoginFormBloc
    extends Bloc<DoctorLoginFormEvent, DoctorLoginFormState> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  DoctorLoginFormBloc() : super( DoctorLoginFormState()) {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    on<EmailChanged>((event, emit) {
      emit(state.copyWith(email: event.email));
    });

    on<PasswordChanged>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
