import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();
  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileReady extends EditProfileState {
  final DoctorModel doctor;
  final File? pickedImage; // local file before upload

  const EditProfileReady({required this.doctor, this.pickedImage});

  EditProfileReady copyWith({DoctorModel? doctor, File? pickedImage}) {
    return EditProfileReady(
      doctor: doctor ?? this.doctor,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }

  @override
  List<Object?> get props => [doctor, pickedImage];
}

class EditProfileSaving extends EditProfileState {
  const EditProfileSaving();
}

class EditProfileSaveSuccess extends EditProfileState {
  final DoctorModel updatedDoctor;
  const EditProfileSaveSuccess(this.updatedDoctor);
  @override
  List<Object?> get props => [updatedDoctor];
}

class EditProfileSaveFailure extends EditProfileState {
  final String message;
  const EditProfileSaveFailure(this.message);
  @override
  List<Object?> get props => [message];
}