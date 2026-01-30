import 'dart:io';

abstract class DoctorApplicationEvent {}

class UpdateGenderEvent extends DoctorApplicationEvent {
  final String gender;
  UpdateGenderEvent(this.gender);
}

class UpdateSpecialistEvent extends DoctorApplicationEvent {
  final String specialist;
  UpdateSpecialistEvent(this.specialist);
}

class PickLicenseFileEvent extends DoctorApplicationEvent {}

class PickProfileImageEvent extends DoctorApplicationEvent {}

class SubmitApplicationEvent extends DoctorApplicationEvent {
  final String name;
  final String place;
  final String email;
  final String password;
  final String confirmPassword; // Added confirmPassword field
  final String phone;
  final String gender;
  final String specialist;
  final String bio;
  final String licenseNumber;
  final int experience;
  final File? licenseFile;
  final File? profileImage;

  SubmitApplicationEvent({
    required this.name,
    required this.place,
    required this.email,
    required this.password,
    required this.confirmPassword, // Added confirmPassword field
    required this.phone,
    required this.gender,
    required this.specialist,
    required this.bio,
    required this.licenseNumber,
    required this.experience,
    this.licenseFile,
    this.profileImage,
  });
}

class ResetApplicationEvent extends DoctorApplicationEvent {}