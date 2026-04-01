import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/added_medications_section.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_doctor_note.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_medication_form.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_patient_chip.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_submit_button.dart';

/// Scrollable body of the prescription screen.
/// Composes all section widgets in order, keeping each section self-contained.
class PrescriptionBody extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final PrescriptionFormState state;
  const PrescriptionBody({
    required this.appointment,
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PrescriptionBloc>();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        PrescriptionPatientChip(name: appointment.patientName),
        const SizedBox(height: 24),

        PrescriptionMedicationForm(state: state),
        const SizedBox(height: 16),

        AddedMedicationsSection(medications: state.addedMedications),
        if (state.addedMedications.isNotEmpty) const SizedBox(height: 16),

        const PrescriptionDoctorNote(),
        const SizedBox(height: 28),

        PrescriptionSubmitButton(
          isSubmitting: state.isSubmitting,
          isEnabled: state.addedMedications.isNotEmpty,
          onTap: () => bloc.add(SubmitPrescription(
            appointmentId: appointment.appointmentId,
            userId: appointment.userId,
            patientName: appointment.patientName,
          )),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}