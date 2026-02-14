import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import '../dialogs/delete_confirmation_dialogs.dart';

class ActionButtonsWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const ActionButtonsWidget({required this.uiState, required this.slotsCache, super.key});

  @override
  Widget build(BuildContext context) {
    final normalizedDay = DateTime(
      uiState.selectedDay.year,
      uiState.selectedDay.month,
      uiState.selectedDay.day,
    );
    final slots = slotsCache[normalizedDay] ?? [];
    final availableSlots = slots.where((s) => s.status == 'available').toList();

    if (availableSlots.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      () =>
                          context
                              .read<ViewSlotsUiCubit>()
                              .toggleSelectionMode(),
                  icon: Icon(
                    uiState.isSelectionMode
                        ? Icons.close
                        : Icons.check_box_outlined,
                  ),
                  label: Text(
                    uiState.isSelectionMode ? 'Cancel' : 'Select Slots',
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF00D4FF),
                    side: const BorderSide(color: Color(0xFF00D4FF)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              if (uiState.isSelectionMode && availableSlots.isNotEmpty) ...[
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    final slotIds =
                        availableSlots.map((s) => s.slotId).toList();
                    context.read<ViewSlotsUiCubit>().selectAllSlots(slotIds);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: const BorderSide(color: Colors.blue),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Select All'),
                ),
              ],
              if (!uiState.isSelectionMode) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed:
                      () => DeleteConfirmationDialogs.deleteAllSlotsForDate(
                        context,
                        availableSlots,
                        uiState.selectedDay,
                      ),
                  icon: const Icon(Icons.delete_sweep),
                  label: const Text('Delete All'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (uiState.isSelectionMode &&
              uiState.selectedSlotIds.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    () => DeleteConfirmationDialogs.deleteSelectedSlots(
                      context,
                      uiState.selectedSlotIds.toList(),
                    ),
                icon: const Icon(Icons.delete_outline),
                label: Text(
                  'Delete ${uiState.selectedSlotIds.length} Selected Slot${uiState.selectedSlotIds.length > 1 ? 's' : ''}',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
