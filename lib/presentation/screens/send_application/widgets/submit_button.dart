import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/handlers/doctor_sign_up_handler.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';

class SubmitButton extends StatelessWidget {
  final DoctorSignUpHandler handler;

  const SubmitButton({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorApplicationBloc, DoctorApplicationState>(
      builder: (context, state) {
        final isLoading = state is DoctorApplicationLoading;
        String? selectedGender;
        String? selectedSpecialist;
        File? licenseFile;
        File? profileImage;

        if (state is DoctorApplicationFormUpdated) {
          selectedGender = state.gender;
          selectedSpecialist = state.specialist;
          licenseFile = state.licenseFile;
          profileImage = state.profileImage;
        }

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    handler.handleSubmitApplication(
                      context,
                      selectedGender: selectedGender,
                      selectedSpecialist: selectedSpecialist,
                      licenseFile: licenseFile,
                      profileImage: profileImage,
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
                side: const BorderSide(
                  color: Color(0xFF6AD2FF),
                  width: 5,
                ),
              ),
              disabledBackgroundColor: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Done',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}