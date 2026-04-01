import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:intl/intl.dart';

class DeleteConfirmationDialogs {
  static void deleteSelectedSlots(BuildContext context, List<String> slotIds) {
    if (slotIds.isEmpty) return;

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
                const SizedBox(width: 12),
                const Expanded(child: Text('Delete Selected Slots')),
              ],
            ),
            content: Text(
              'Are you sure you want to delete ${slotIds.length} selected '
              'slot${slotIds.length > 1 ? 's' : ''}? This action cannot be undone.',
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<SlotBloc>().add(
                    DeleteMultipleSlotsEvent(slotIds),
                  );
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  static void deleteAllSlotsForDate(
    BuildContext context,
    List<SlotModel> availableSlots,
    DateTime selectedDay,
  ) {
    if (availableSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available slots to delete for this date'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[700]),
                const SizedBox(width: 12),
                const Expanded(child: Text('Delete All Slots')),
              ],
            ),
            content: Text(
              'Are you sure you want to delete all ${availableSlots.length} available '
              'slot${availableSlots.length > 1 ? 's' : ''} for '
              '${DateFormat('MMM dd, yyyy').format(selectedDay)}? '
              'This action cannot be undone.',
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<SlotBloc>().add(
                    DeleteMultipleSlotsEvent(
                      availableSlots.map((s) => s.slotId).toList(),
                    ),
                  );
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete All'),
              ),
            ],
          ),
    );
  }
}
