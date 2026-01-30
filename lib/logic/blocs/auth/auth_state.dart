import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';

abstract class DoctorAuthState extends Equatable {
  const DoctorAuthState();
  
  @override
  List<Object?> get props => [];
}

class DoctorAuthInitial extends DoctorAuthState {}

class DoctorAuthLoading extends DoctorAuthState {}

class DoctorAuthSuccess extends DoctorAuthState {
  final DoctorModel doctor;
  
  const DoctorAuthSuccess(this.doctor);
  
  @override
  List<Object?> get props => [doctor];
}

class DoctorAuthFailure extends DoctorAuthState {
  final String error;
  
  const DoctorAuthFailure(this.error);
  
  @override
  List<Object?> get props => [error];
}