import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_form.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_form_controllers.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  static EditProfileReady? _lastReady;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
  if (state is EditProfileSaveSuccess) {
    _lastReady = null; // clear stale cache
    EditProfileFormControllers.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.gradientColor, size: 20),
            const SizedBox(width: 10),
            Text('Profile updated successfully',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
        backgroundColor: AppColors.completed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context, state.updatedDoctor); // ✅ passes updated doctor back
  } else if (state is EditProfileSaveFailure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message,
            style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: AppColors.cancelled,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
},
      builder: (context, state) {
        // Cache the last ready state so the saving overlay still has data
        if (state is EditProfileReady) {
          _lastReady = state;
        }

        if (state is EditProfileInitial || _lastReady == null) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            body: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return EditProfileForm(
          doctor: _lastReady!.doctor,
          pickedImage: _lastReady!.pickedImage,
          isSaving: state is EditProfileSaving,
        );
      },
    );
  }
}