import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/cubits/profile/edit_profile/edit_profile_form_state.dart';

class EditProfileFormCubit extends Cubit<EditProfileFormState> {
  EditProfileFormCubit(DoctorModel doctor)
      : super(EditProfileFormState(
          selectedSpecialist: doctor.specialist,
          selectedGender: doctor.gender,
        ));

  void selectSpecialist(String? value) =>
      emit(state.copyWith(selectedSpecialist: value));

  void selectGender(String? value) =>
      emit(state.copyWith(selectedGender: value));
}