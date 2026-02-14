import 'package:equatable/equatable.dart';

abstract class DoctorAppointmentEvent extends Equatable {
  const DoctorAppointmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchDoctorAppointments extends DoctorAppointmentEvent {
  final String doctorId;

  const FetchDoctorAppointments(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

class MarkAppointmentCompleted extends DoctorAppointmentEvent {
  final String appointmentId;

  const MarkAppointmentCompleted(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class AddPrescriptionEvent extends DoctorAppointmentEvent {
  final String appointmentId;
  final String prescription;

  const AddPrescriptionEvent({
    required this.appointmentId,
    required this.prescription,
  });

  @override
  List<Object?> get props => [appointmentId, prescription];
}

class CancelAppointmentEvent extends DoctorAppointmentEvent {
  final String appointmentId;

  const CancelAppointmentEvent(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}