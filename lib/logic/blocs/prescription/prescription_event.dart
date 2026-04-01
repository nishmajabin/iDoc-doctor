
abstract class PrescriptionEvent {
  const PrescriptionEvent();
}

// ── Form field events ────────────────────────────────────────────────────────

class UpdateMedicationName extends PrescriptionEvent {
  final String name;
  const UpdateMedicationName(this.name);
}

class IncrementDosage extends PrescriptionEvent {
  const IncrementDosage();
}

class DecrementDosage extends PrescriptionEvent {
  const DecrementDosage();
}

class IncrementDuration extends PrescriptionEvent {
  const IncrementDuration();
}

class DecrementDuration extends PrescriptionEvent {
  const DecrementDuration();
}

class UpdateDurationUnit extends PrescriptionEvent {
  final String unit;
  const UpdateDurationUnit(this.unit);
}

class UpdateRepeat extends PrescriptionEvent {
  final String repeat;
  const UpdateRepeat(this.repeat);
}

class UpdateTimeOfDay extends PrescriptionEvent {
  final String timeOfDay;
  const UpdateTimeOfDay(this.timeOfDay);
}

class UpdateBeTaken extends PrescriptionEvent {
  final String beTaken;
  const UpdateBeTaken(this.beTaken);
}

class UpdateDoctorNote extends PrescriptionEvent {
  final String note;
  const UpdateDoctorNote(this.note);
}

// ── List management ──────────────────────────────────────────────────────────

class AddMedicationToList extends PrescriptionEvent {
  const AddMedicationToList();
}

class RemoveMedicationFromList extends PrescriptionEvent {
  final int index;
  const RemoveMedicationFromList(this.index);
}

// ── Submit ───────────────────────────────────────────────────────────────────

class SubmitPrescription extends PrescriptionEvent {
  final String appointmentId;
  final String userId;
  final String patientName;
  const SubmitPrescription({
    required this.appointmentId,
    required this.userId,
    required this.patientName,
  });
}

// ── View prescriptions ───────────────────────────────────────────────────────

class LoadPrescriptions extends PrescriptionEvent {
  final String appointmentId;
  const LoadPrescriptions(this.appointmentId);
}

class ClearMedicationName extends PrescriptionEvent {
  const ClearMedicationName();
}