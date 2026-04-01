import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/handlers/auth/sign_up_handler.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/profile_image_picker.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/doctor_form_fields.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/widgets/submit_button.dart';

class DoctorDetailsScreen extends StatelessWidget {
  DoctorDetailsScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _licenseController = TextEditingController();
  final _experienceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final handler = DoctorSignUpHandler(
      formKey: _formKey,
      nameController: _nameController,
      placeController: _placeController,
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      phoneController: _phoneController,
      bioController: _bioController,
      licenseController: _licenseController,
      experienceController: _experienceController,
    );

    return BlocProvider(
      create: (context) => DoctorApplicationBloc(),
      child: BlocListener<DoctorApplicationBloc, DoctorApplicationState>(
        listener:
            (context, state) =>
                handler.handleDoctorApplicationState(context, state),
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gradientColor,
                  AppColors.gradientMainColor.withValues(alpha: 0.01),
                ],
                stops: [0.1, 1],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 27.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const ProfileImagePicker(),
                            const SizedBox(height: 50),
                            DoctorFormFields(
                              nameController: _nameController,
                              placeController: _placeController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmPasswordController:
                                  _confirmPasswordController,
                              phoneController: _phoneController,
                              bioController: _bioController,
                              licenseController: _licenseController,
                              experienceController: _experienceController,
                            ),
                            const SizedBox(height: 50),
                            SubmitButton(handler: handler),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        Expanded(
          child: Text(
            'DETAILS',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
