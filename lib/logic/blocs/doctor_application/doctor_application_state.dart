import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class DoctorApplicationState extends Equatable {
  const DoctorApplicationState();
  
  @override
  List<Object?> get props => [];
}

class DoctorApplicationInitial extends DoctorApplicationState {}

class DoctorApplicationFormUpdated extends DoctorApplicationState {
  final String? gender;
  final String? specialist;
  final File? licenseFile;
  final String? licenseFileName;
  final File? profileImage;
  final String? profileImageName;

  const DoctorApplicationFormUpdated({
    this.gender,
    this.specialist,
    this.licenseFile,
    this.licenseFileName,
    this.profileImage,
    this.profileImageName,
  });

  @override
  List<Object?> get props => [
    gender,
    specialist,
    licenseFile,
    licenseFileName,
    profileImage,
    profileImageName,
  ];
}

class DoctorApplicationLoading extends DoctorApplicationState {}

class DoctorApplicationSuccess extends DoctorApplicationState {
  final String message;
  final String doctorId;

  const DoctorApplicationSuccess(this.message, this.doctorId);

  @override
  List<Object> get props => [message, doctorId];
}

class DoctorApplicationFailure extends DoctorApplicationState {
  final String error;
  final String? gender;
  final String? specialist;
  final File? licenseFile;
  final String? licenseFileName;
  final File? profileImage;
  final String? profileImageName;

  const DoctorApplicationFailure(
    this.error, {
    this.gender,
    this.specialist,
    this.licenseFile,
    this.licenseFileName,
    this.profileImage,
    this.profileImageName,
  });

  @override
  List<Object?> get props => [
    error,
    gender,
    specialist,
    licenseFile,
    licenseFileName,
    profileImage,
    profileImageName,
  ];
}