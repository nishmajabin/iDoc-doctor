import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/prescription_options.dart';
import 'package:idoc_doctor_side/core/utils/prescription_input_decoration.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/add_medication_button.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/counter_row.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_section_card.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/section_label.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/toggle_option_bar.dart';

/// Renders the "Medication" section card containing all form controls needed
/// to configure and add a single medication entry to the prescription.
class PrescriptionMedicationForm extends StatelessWidget {
  final PrescriptionFormState state;
  const PrescriptionMedicationForm({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PrescriptionBloc>();

    return PrescriptionSectionCard(
      title: 'Medication',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key resets the TextField whenever a medication is added (clears input).
          TextField(
            key: ValueKey(state.addedMedications.length),
            onChanged: (v) => bloc.add(UpdateMedicationName(v)),
            style: const TextStyle(fontSize: 14, color: Color(0xFF0D0D0D)),
            decoration: prescriptionInputDecoration('Medication name'),
          ),
          const SizedBox(height: 20),
          CounterRow(
            label: 'Dosage',
            valueLabel: '${state.dosage} Tablet',
            onIncrement: () => bloc.add(const IncrementDosage()),
            onDecrement: () => bloc.add(const DecrementDosage()),
          ),
          const SizedBox(height: 16),
          CounterRow(
            label: 'Duration',
            valueLabel: '${state.duration} ${state.durationUnit}',
            onIncrement: () => bloc.add(const IncrementDuration()),
            onDecrement: () => bloc.add(const DecrementDuration()),
          ),
          const SizedBox(height: 10),
          ToggleOptionBar(
            options: PrescriptionOptions.durationUnit,
            selected: state.durationUnit,
            onSelect: (v) => bloc.add(UpdateDurationUnit(v)),
          ),
          const SizedBox(height: 20),
          const SectionLabel('Repeat'),
          ToggleOptionBar(
            options: PrescriptionOptions.repeat,
            selected: state.repeat,
            onSelect: (v) => bloc.add(UpdateRepeat(v)),
          ),
          const SizedBox(height: 20),
          const SectionLabel('Time of Day'),
          ToggleOptionBar(
            options: PrescriptionOptions.timeOfDay,
            selected: state.timeOfDay,
            onSelect: (v) => bloc.add(UpdateTimeOfDay(v)),
          ),
          const SizedBox(height: 20),
          const SectionLabel('To be Taken'),
          ToggleOptionBar(
            options: PrescriptionOptions.beTaken,
            selected: state.beTaken,
            onSelect: (v) => bloc.add(UpdateBeTaken(v)),
          ),
          const SizedBox(height: 24),
          AddMedicationButton(
            onTap: () => bloc.add(const AddMedicationToList()),
          ),
        ],
      ),
    );
  }
}