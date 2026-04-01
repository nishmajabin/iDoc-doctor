
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
  @override
  List<Object?> get props => [];
}

class EditProfileStarted extends EditProfileEvent {
  final DoctorModel doctor;
  const EditProfileStarted(this.doctor);
  @override
  List<Object?> get props => [doctor];
}

class EditProfileImagePicked extends EditProfileEvent {
  final File image;
  const EditProfileImagePicked(this.image);
  @override
  List<Object?> get props => [image];
}

class EditProfileSubmitted extends EditProfileEvent {
  final String name;
  final String phone;
  final String place;
  final String bio;
  final String specialist;
  final String gender;
  final int experience;
  final File? newProfileImage;

  const EditProfileSubmitted({
    required this.name,
    required this.phone,
    required this.place,
    required this.bio,
    required this.specialist,
    required this.gender,
    required this.experience,
    this.newProfileImage,
  });

  @override
  List<Object?> get props => [
        name, phone, place, bio, specialist, gender, experience, newProfileImage
      ];
}