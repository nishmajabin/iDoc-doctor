import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_event.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';
import 'package:idoc_doctor_side/presentation/screens/send_application/screen/application_success_screen.dart';

class DoctorSignUpHandler {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController placeController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final TextEditingController bioController;
  final TextEditingController licenseController;
  final TextEditingController experienceController;

  DoctorSignUpHandler({
    required this.formKey,
    required this.nameController,
    required this.placeController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.bioController,
    required this.licenseController,
    required this.experienceController,
  });

  void handleDoctorApplicationState(
    BuildContext context,
    DoctorApplicationState state,
  ) {
    if (state is DoctorApplicationSuccess) {
      _showSnackBar(
        context,
        state.message,
        isError: false,
      );
      _clearAllFields();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ApplicationSuccessScreen(),
        ),
      );
    } else if (state is DoctorApplicationFailure) {
      _showSnackBar(
        context,
        state.error,
        isError: true,
      );
    }
  }

  void handleSubmitApplication(
    BuildContext context, {
    required String? selectedGender,
    required String? selectedSpecialist,
    required File? licenseFile,
    required File? profileImage,
  }) {
    // First validate the form fields
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validate profile image
    if (profileImage == null) {
      _showSnackBar(context, 'Please select a profile image');
      return;
    }

    // Validate gender
    if (selectedGender == null) {
      _showSnackBar(context, 'Please select gender');
      return;
    }

    // Validate specialist
    if (selectedSpecialist == null) {
      _showSnackBar(context, 'Please select a specialist');
      return;
    }

    // Validate license file
    if (licenseFile == null) {
      _showSnackBar(context, 'Please upload license proof');
      return;
    }

    // Parse experience
    final experience = int.tryParse(
          experienceController.text.replaceAll(RegExp(r'\D'), ''),
        ) ??
        0;

    // Submit application
    context.read<DoctorApplicationBloc>().add(
          SubmitApplicationEvent(
            name: nameController.text.trim(),
            place: placeController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            confirmPassword: confirmPasswordController.text.trim(),
            phone: phoneController.text.trim(),
            gender: selectedGender,
            specialist: selectedSpecialist,
            bio: bioController.text.trim(),
            licenseNumber: licenseController.text.trim(),
            experience: experience,
            licenseFile: licenseFile,
            profileImage: profileImage,
          ),
        );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: isError ? 4 : 3),
      ),
    );
  }

  void _clearAllFields() {
    nameController.clear();
    placeController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    bioController.clear();
    licenseController.clear();
    experienceController.clear();
  }
}