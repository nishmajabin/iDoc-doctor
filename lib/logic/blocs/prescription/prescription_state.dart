import 'package:idoc_doctor_side/data/models/prescription_model.dart';

abstract class PrescriptionState {
  const PrescriptionState();
}

class PrescriptionInitial extends PrescriptionState {}

// ── Form state (used on write screen) ───────────────────────────────────────

class PrescriptionFormState extends PrescriptionState {
  final String medicationName;
  final int dosage;
  final int duration;
  final String durationUnit;
  final String repeat;
  final String timeOfDay;
  final String beTaken;
  final String doctorNote;
  final List<PrescriptionMedication> addedMedications;
  final bool isSubmitting;

  const PrescriptionFormState({
    this.medicationName = '',
    this.dosage = 1,
    this.duration = 1,
    this.durationUnit = 'Week',
    this.repeat = 'Everyday',
    this.timeOfDay = 'Morning',
    this.beTaken = 'After Food',
    this.doctorNote = '',
    this.addedMedications = const [],
    this.isSubmitting = false,
  });

  PrescriptionFormState copyWith({
    String? medicationName,
    int? dosage,
    int? duration,
    String? durationUnit,
    String? repeat,
    String? timeOfDay,
    String? beTaken,
    String? doctorNote,
    List<PrescriptionMedication>? addedMedications,
    bool? isSubmitting,
  }) =>
      PrescriptionFormState(
        medicationName: medicationName ?? this.medicationName,
        dosage: dosage ?? this.dosage,
        duration: duration ?? this.duration,
        durationUnit: durationUnit ?? this.durationUnit,
        repeat: repeat ?? this.repeat,
        timeOfDay: timeOfDay ?? this.timeOfDay,
        beTaken: beTaken ?? this.beTaken,
        doctorNote: doctorNote ?? this.doctorNote,
        addedMedications: addedMedications ?? this.addedMedications,
        isSubmitting: isSubmitting ?? this.isSubmitting,
      );
}

class PrescriptionSubmitSuccess extends PrescriptionState {}

class PrescriptionSubmitError extends PrescriptionState {
  final String message;
  const PrescriptionSubmitError(this.message);
}

// ── View state (used on read screen) ────────────────────────────────────────

class PrescriptionViewLoading extends PrescriptionState {}

class PrescriptionViewLoaded extends PrescriptionState {
  final List<PrescriptionRecord> records;
  const PrescriptionViewLoaded(this.records);
}

class PrescriptionViewError extends PrescriptionState {
  final String message;
  const PrescriptionViewError(this.message);
}