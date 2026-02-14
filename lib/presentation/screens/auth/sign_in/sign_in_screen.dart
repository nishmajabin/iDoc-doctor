import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_event.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_login_form/login_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_login_form/login_form_state.dart';
import 'package:idoc_doctor_side/presentation/bottom_nav/bottom_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/widgets/admin_contact_section.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/widgets/custom_button.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/widgets/login_form_section.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/widgets/login_header.dart';

class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => DoctorLoginFormBloc())],
      child: const DoctorLoginView(),
    );
  }
}

class DoctorLoginView extends StatelessWidget {
  const DoctorLoginView({super.key});

  void _handleLogin(BuildContext context, DoctorLoginFormState formState) {
    if (formState.isEmailValid && formState.isPasswordValid) {
      context.read<DoctorAuthBloc>().add(
            DoctorLoginRequested(
              email: formState.email,
              password: formState.password,
            ),
          );
    }
  }

  void _showBlockedDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.block,
                color: Colors.red.shade700,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Account Blocked',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Contact admin support for more information',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<DoctorAuthBloc, DoctorAuthState>(
        listener: (context, state) {
          if (state is DoctorAuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomScreen(doctor: state.doctor),
              ),
            );
          } else if (state is DoctorAuthBlocked) {
            // Show blocked dialog
            _showBlockedDialog(context, state.message);
          } else if (state is DoctorAuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LoginHeader(),
                const LoginFormSection(),
                const SizedBox(height: 50),
                BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
                  builder: (context, authState) {
                    return BlocBuilder<DoctorLoginFormBloc,
                        DoctorLoginFormState>(
                      builder: (context, formState) {
                        return CustomButton(
                          text: 'Login',
                          onPressed: authState is DoctorAuthLoading
                              ? null
                              : () => _handleLogin(context, formState),
                          isLoading: authState is DoctorAuthLoading,
                        );
                      },
                    );
                  },
                ),
                const AdminContactSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}