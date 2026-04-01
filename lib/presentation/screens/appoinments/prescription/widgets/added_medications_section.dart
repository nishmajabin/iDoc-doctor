import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/prescription_model.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/medication_card.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_section_card.dart';

/// Displays the list of medications that have already been added to the
/// prescription. Renders nothing when the list is empty.
class AddedMedicationsSection extends StatelessWidget {
  final List<PrescriptionMedication> medications;
  const AddedMedicationsSection({required this.medications, super.key});

  @override
  Widget build(BuildContext context) {
    if (medications.isEmpty) return const SizedBox.shrink();

    final bloc = context.read<PrescriptionBloc>();

    return PrescriptionSectionCard(
      title: 'Added Medications (${medications.length})',
      child: Column(
        children: medications.asMap().entries.map((entry) {
          return MedicationCard(
            med: entry.value,
            index: entry.key,
            onRemove: () => bloc.add(RemoveMedicationFromList(entry.key)),
          );
        }).toList(),
      ),
    );
  }
}