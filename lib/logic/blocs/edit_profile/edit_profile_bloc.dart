import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/repositories/edit_profile_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_event.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_state.dart';


class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileRepository _repository;

  EditProfileBloc({EditProfileRepository? repository})
      : _repository = repository ?? EditProfileRepository(),
        super(const EditProfileInitial()) {
    on<EditProfileStarted>(_onStarted);
    on<EditProfileImagePicked>(_onImagePicked);
    on<EditProfileSubmitted>(_onSubmitted);
  }

  void _onStarted(
    EditProfileStarted event,
    Emitter<EditProfileState> emit,
  ) {
    emit(EditProfileReady(doctor: event.doctor));
  }

  void _onImagePicked(
    EditProfileImagePicked event,
    Emitter<EditProfileState> emit,
  ) {
    if (state is! EditProfileReady) return;
    final current = state as EditProfileReady;
    emit(current.copyWith(pickedImage: event.image));
  }

  Future<void> _onSubmitted(
    EditProfileSubmitted event,
    Emitter<EditProfileState> emit,
  ) async {
    if (state is! EditProfileReady) return;
    final current = state as EditProfileReady;

    emit(const EditProfileSaving());

    try {
      final updated = await _repository.updateProfile(
        doctor: current.doctor,
        name: event.name,
        phone: event.phone,
        place: event.place,
        bio: event.bio,
        specialist: event.specialist,
        gender: event.gender,
        experience: event.experience,
        newProfileImage: event.newProfileImage,
      );
      emit(EditProfileSaveSuccess(updated));
    } catch (e) {
      emit(EditProfileSaveFailure(e.toString()));
      // Restore ready state so the form remains usable
      emit(EditProfileReady(
        doctor: current.doctor,
        pickedImage: current.pickedImage,
      ));
    }
  }
}