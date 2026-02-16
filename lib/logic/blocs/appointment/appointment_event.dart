// import 'package:equatable/equatable.dart';

// abstract class DoctorAppointmentEvent extends Equatable {
//   const DoctorAppointmentEvent();

//   @override
//   List<Object?> get props => [];
// }

// class FetchDoctorAppointments extends DoctorAppointmentEvent {
//   final String doctorId;

//   const FetchDoctorAppointments(this.doctorId);

//   @override
//   List<Object?> get props => [doctorId];
// }

// class MarkAppointmentCompleted extends DoctorAppointmentEvent {
//   final String appointmentId;

//   const MarkAppointmentCompleted(this.appointmentId);

//   @override
//   List<Object?> get props => [appointmentId];
// }

// class AddPrescriptionEvent extends DoctorAppointmentEvent {
//   final String appointmentId;
//   final String prescription;

//   const AddPrescriptionEvent({
//     required this.appointmentId,
//     required this.prescription,
//   });

//   @override
//   List<Object?> get props => [appointmentId, prescription];
// }

// class CancelAppointmentEvent extends DoctorAppointmentEvent {
//   final String appointmentId;

//   const CancelAppointmentEvent(this.appointmentId);

//   @override
//   List<Object?> get props => [appointmentId];
// }

import 'package:equatable/equatable.dart';

abstract class DoctorAppointmentEvent extends Equatable {
  const DoctorAppointmentEvent();

  @override
  List<Object?> get props => [];
}

/// Load all appointments for [doctorId] with a full loading spinner.
class FetchDoctorAppointments extends DoctorAppointmentEvent {
  final String doctorId;

  const FetchDoctorAppointments(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

/// Silently re-sync without a full loading spinner (pull-to-refresh).
/// Keeps the current list visible while new data is fetched.
class RefreshDoctorAppointments extends DoctorAppointmentEvent {
  final String doctorId;

  const RefreshDoctorAppointments(this.doctorId);

  @override
  List<Object?> get props => [doctorId];
}

/// Mark an appointment as completed by [appointmentId].
class MarkAppointmentCompleted extends DoctorAppointmentEvent {
  final String appointmentId;

  const MarkAppointmentCompleted(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Add or update a prescription for [appointmentId].
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
class SwitchAppointmentTab extends DoctorAppointmentEvent {
  final bool isUpcoming;
  const SwitchAppointmentTab(this.isUpcoming);

  @override
  List<Object?> get props => [isUpcoming];
}