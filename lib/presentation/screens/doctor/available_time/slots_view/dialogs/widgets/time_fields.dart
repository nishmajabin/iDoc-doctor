import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_state.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/dialogs/widgets/time_field.dart';

class SlotTimeFields extends StatelessWidget {
  final EditSlotState state;

  const SlotTimeFields({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SlotTimeField(
            label: 'Start Time',
            time: state.startTime,
            onTap: () => _pickTime(
              context,
              state.startTime,
              (t) => context.read<EditSlotCubit>().updateStartTime(t),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('to'),
        ),
        Expanded(
          child: SlotTimeField(
            label: 'End Time',
            time: state.endTime,
            onTap: () => _pickTime(
              context,
              state.endTime,
              (t) => context.read<EditSlotCubit>().updateEndTime(t),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay initial,
    ValueChanged<TimeOfDay> onPicked,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      onPicked(picked);
    }
  }
}
