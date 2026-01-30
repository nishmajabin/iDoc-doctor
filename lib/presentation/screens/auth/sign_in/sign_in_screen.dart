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
                    return BlocBuilder<
                      DoctorLoginFormBloc,
                      DoctorLoginFormState
                    >(
                      builder: (context, formState) {
                        return CustomButton(
                          text: 'Login',
                          onPressed:
                              authState is DoctorAuthLoading
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
