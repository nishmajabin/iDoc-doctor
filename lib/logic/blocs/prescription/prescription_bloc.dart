import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/prescription_model.dart';
import 'package:idoc_doctor_side/core/data/services/prescription_service.dart';
import 'prescription_event.dart';
import 'prescription_state.dart';

class PrescriptionBloc extends Bloc<PrescriptionEvent, PrescriptionState> {
  final PrescriptionService service;

  PrescriptionBloc(this.service) : super(PrescriptionFormState()) {
    on<UpdateMedicationName>(_onUpdateName);
    on<IncrementDosage>(_onIncrementDosage);
    on<DecrementDosage>(_onDecrementDosage);
    on<IncrementDuration>(_onIncrementDuration);
    on<DecrementDuration>(_onDecrementDuration);
    on<UpdateDurationUnit>(_onUpdateDurationUnit);
    on<UpdateRepeat>(_onUpdateRepeat);
    on<UpdateTimeOfDay>(_onUpdateTimeOfDay);
    on<UpdateBeTaken>(_onUpdateBeTaken);
    on<UpdateDoctorNote>(_onUpdateNote);
    on<AddMedicationToList>(_onAddMedication);
    on<RemoveMedicationFromList>(_onRemoveMedication);
    on<SubmitPrescription>(_onSubmit);
    on<LoadPrescriptions>(_onLoadPrescriptions);
    on<ClearMedicationName>(_onClearMedicationName);
  }

  PrescriptionFormState get _form => state as PrescriptionFormState;

  void _onUpdateName(UpdateMedicationName e, Emitter emit) =>
      emit(_form.copyWith(medicationName: e.name));

  void _onIncrementDosage(IncrementDosage e, Emitter emit) =>
      emit(_form.copyWith(dosage: _form.dosage + 1));

  void _onDecrementDosage(DecrementDosage e, Emitter emit) {
    if (_form.dosage > 1) emit(_form.copyWith(dosage: _form.dosage - 1));
  }

  void _onIncrementDuration(IncrementDuration e, Emitter emit) =>
      emit(_form.copyWith(duration: _form.duration + 1));

  void _onDecrementDuration(DecrementDuration e, Emitter emit) {
    if (_form.duration > 1) emit(_form.copyWith(duration: _form.duration - 1));
  }

  void _onUpdateDurationUnit(UpdateDurationUnit e, Emitter emit) =>
      emit(_form.copyWith(durationUnit: e.unit));

  void _onUpdateRepeat(UpdateRepeat e, Emitter emit) =>
      emit(_form.copyWith(repeat: e.repeat));

  void _onUpdateTimeOfDay(UpdateTimeOfDay e, Emitter emit) =>
      emit(_form.copyWith(timeOfDay: e.timeOfDay));

  void _onUpdateBeTaken(UpdateBeTaken e, Emitter emit) =>
      emit(_form.copyWith(beTaken: e.beTaken));

  void _onUpdateNote(UpdateDoctorNote e, Emitter emit) =>
      emit(_form.copyWith(doctorNote: e.note));

  void _onAddMedication(AddMedicationToList e, Emitter emit) {
    if (_form.medicationName.trim().isEmpty) return;

    final med = PrescriptionMedication(
      medication: _form.medicationName.trim(),
      dosage: _form.dosage,
      duration: _form.duration,
      durationUnit: _form.durationUnit,
      repeat: _form.repeat,
      timeOfDay: _form.timeOfDay,
      beTaken: _form.beTaken,
    );

    emit(_form.copyWith(
      addedMedications: [..._form.addedMedications, med],
      medicationName: '',
      dosage: 1,
      duration: 1,
      durationUnit: 'Week',
      repeat: 'Everyday',
      timeOfDay: 'Morning',
      beTaken: 'After Food',
    ));
  }

  void _onRemoveMedication(RemoveMedicationFromList e, Emitter emit) {
    final updated = List<PrescriptionMedication>.from(_form.addedMedications)
      ..removeAt(e.index);
    emit(_form.copyWith(addedMedications: updated));
  }

  Future<void> _onSubmit(SubmitPrescription e, Emitter emit) async {
    if (_form.addedMedications.isEmpty) return;

    emit(_form.copyWith(isSubmitting: true));
    try {
      await service.submitPrescription(
        appointmentId: e.appointmentId,
        userId: e.userId,
        patientName: e.patientName,
        docNote: _form.doctorNote,
        medications: _form.addedMedications,
      );
      emit(PrescriptionSubmitSuccess());
    } catch (err) {
      emit(PrescriptionSubmitError(err.toString()));
      // Restore form after error
      emit(_form.copyWith(isSubmitting: false));
    }
  }

  Future<void> _onLoadPrescriptions(
      LoadPrescriptions e, Emitter emit) async {
    emit(PrescriptionViewLoading());
    try {
      final records = await service.fetchPrescriptions(e.appointmentId);
      emit(PrescriptionViewLoaded(records));
    } catch (err) {
      emit(PrescriptionViewError(err.toString()));
    }
  }

  void _onClearMedicationName(ClearMedicationName e, Emitter emit) =>
    emit(_form.copyWith(medicationName: ''));
}