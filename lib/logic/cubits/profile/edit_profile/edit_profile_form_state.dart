class EditProfileFormState {
  final String? selectedSpecialist;
  final String? selectedGender;

  const EditProfileFormState({
    this.selectedSpecialist,
    this.selectedGender,
  });

  EditProfileFormState copyWith({
    String? selectedSpecialist,
    String? selectedGender,
  }) {
    return EditProfileFormState(
      selectedSpecialist: selectedSpecialist ?? this.selectedSpecialist,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}