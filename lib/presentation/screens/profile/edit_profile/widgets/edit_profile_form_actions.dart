import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_event.dart';
import 'package:idoc_doctor_side/logic/cubits/profile/edit_profile/edit_profile_form_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_form_controllers.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileFormActions {
  const EditProfileFormActions._(); // prevent instantiation

  static Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      // ignore: use_build_context_synchronously
      context
          .read<EditProfileBloc>()
          .add(EditProfileImagePicked(File(picked.path)));
    }
  }

  static void submit({
    required BuildContext context,
    required EditProfileFormState formState,
    required DoctorModel doctor,
    required File? pickedImage,
  }) {
    if (!EditProfileFormControllers.formKey.currentState!.validate()) return;

    final experience = int.tryParse(
          EditProfileFormControllers.experienceCtrl.text
              .replaceAll(RegExp(r'\D'), ''),
        ) ?? 0;

    context.read<EditProfileBloc>().add(
          EditProfileSubmitted(
            name:             EditProfileFormControllers.nameCtrl.text,
            phone:            EditProfileFormControllers.phoneCtrl.text,
            place:            EditProfileFormControllers.placeCtrl.text,
            bio:              EditProfileFormControllers.bioCtrl.text,
            specialist:       formState.selectedSpecialist ?? doctor.specialist,
            gender:           formState.selectedGender ?? doctor.gender,
            experience:       experience,
            newProfileImage:  pickedImage,
          ),
        );
  }
}