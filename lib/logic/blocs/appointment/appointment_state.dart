import 'package:idoc_doctor_side/data/models/appointment_model.dart';

abstract class DoctorAppointmentState {}

class DoctorAppointmentInitial extends DoctorAppointmentState {}

class DoctorAppointmentLoading extends DoctorAppointmentState {}

class DoctorAppointmentLoaded extends DoctorAppointmentState {
  final List<DoctorAppointmentModel> upcoming;
  final List<DoctorAppointmentModel> past;

  DoctorAppointmentLoaded({
    required this.upcoming,
    required this.past,
  });
}

class DoctorAppointmentError extends DoctorAppointmentState {
  final String message;
  DoctorAppointmentError(this.message);
}
