abstract class DoctorAppointmentEvent {}

class FetchDoctorAppointments extends DoctorAppointmentEvent {
  final String doctorId;
  FetchDoctorAppointments(this.doctorId);
}

class MarkAppointmentCompleted extends DoctorAppointmentEvent {
  final String appointmentId;
  MarkAppointmentCompleted(this.appointmentId);
}

class AddPrescriptionEvent extends DoctorAppointmentEvent {
  final String appointmentId;
  final String prescription;
  AddPrescriptionEvent(this.appointmentId, this.prescription);
}
