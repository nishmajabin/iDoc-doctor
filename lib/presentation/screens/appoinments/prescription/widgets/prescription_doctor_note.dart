import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/utils/prescription_input_decoration.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_section_card.dart';

/// The optional free-text note section the doctor can fill in for the patient.
class PrescriptionDoctorNote extends StatelessWidget {
  const PrescriptionDoctorNote({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PrescriptionBloc>();

    return PrescriptionSectionCard(
      title: "Doctor's Note",
      child: TextField(
        maxLines: 4,
        onChanged: (v) => bloc.add(UpdateDoctorNote(v)),
        style: const TextStyle(fontSize: 14, color: Color(0xFF0D0D0D)),
        decoration: prescriptionInputDecoration('Optional notes for the patient...'),
      ),
    );
  }
}