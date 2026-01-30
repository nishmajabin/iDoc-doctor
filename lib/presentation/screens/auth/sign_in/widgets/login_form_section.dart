import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_login_form/login_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_login_form/login_form_event.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_login_form/login_form_state.dart';
import 'custom_text_field.dart';

class LoginFormSection extends StatelessWidget {
  const LoginFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loginFormBloc = context.read<DoctorLoginFormBloc>();

    return BlocBuilder<DoctorLoginFormBloc, DoctorLoginFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: loginFormBloc.emailController,
              hintText: 'Enter your email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                context.read<DoctorLoginFormBloc>().add(EmailChanged(value));
              },
              validator: (value) {
                if (!state.isEmailValid && state.email.isNotEmpty) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Password',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: loginFormBloc.passwordController,
              hintText: 'Enter your password',
              prefixIcon: Icons.lock_outline,
              obscureText: state.obscurePassword,
              onChanged: (value) {
                context.read<DoctorLoginFormBloc>().add(PasswordChanged(value));
              },
              suffixIcon: IconButton(
                icon: Icon(
                  state.obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: () {
                  context.read<DoctorLoginFormBloc>().add(
                    TogglePasswordVisibility(),
                  );
                },
              ),
              validator: (value) {
                if (!state.isPasswordValid && state.password.isNotEmpty) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
          ],
        );
      },
    );
  }
}
