import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/edit_slot/edit_slot_state.dart';
import 'package:idoc_doctor_side/core/utils/time_formatter.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/dialogs/widgets/info_box.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/dialogs/widgets/time_fields.dart';

class EditSlotBody extends StatelessWidget {
  final SlotModel slot;

  const EditSlotBody({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSlotCubit, EditSlotState>(
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.edit_calendar, color: Color(0xFF00D4FF)),
              SizedBox(width: 12),
              Expanded(child: Text('Edit Slot Time')),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SlotInfoBox(slot: slot),
              const SizedBox(height: 20),
              SlotTimeFields(state: state),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D4FF),
                foregroundColor: Colors.white,
              ),
              onPressed: () => _save(context, state),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _save(BuildContext context, EditSlotState state) {
    final startMinutes =
        state.startTime.hour * 60 + state.startTime.minute;
    final endMinutes =
        state.endTime.hour * 60 + state.endTime.minute;

    if (endMinutes <= startMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('End time must be after start time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<SlotBloc>().add(
          UpdateSlotEvent(
            slotId: slot.slotId,
            startTime:
                TimeFormatter.to24HourString(state.startTime),
            endTime:
                TimeFormatter.to24HourString(state.endTime),
          ),
        );

    Navigator.pop(context);
  }
}
