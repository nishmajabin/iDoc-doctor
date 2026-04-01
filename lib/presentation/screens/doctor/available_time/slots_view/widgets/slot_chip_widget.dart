import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/utils/time_utils.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_state.dart';
import '../dialogs/edit_slot_dialog.dart';

class SlotChipWidget extends StatelessWidget {
  final SlotModel slot;
  final Color color;
  final ViewSlotsUiState uiState;

  const SlotChipWidget({
    required this.slot,
    required this.color,
    required this.uiState,
    super.key
  });

  bool _canEditSlot(SlotModel slot) {
    if (slot.status != 'available') return false;
    final timeSinceCreation = DateTime.now().difference(slot.createdAt);
    return timeSinceCreation.inMinutes <= 60;
  }

  @override
  Widget build(BuildContext context) {
    final canEdit = _canEditSlot(slot);
    final isSelected = uiState.selectedSlotIds.contains(slot.slotId);
    final displayStart = formatTimeToAmPm(slot.startTime);
    final displayEnd = formatTimeToAmPm(slot.endTime);

    return GestureDetector(
      onTap:
          slot.status == 'available'
              ? (uiState.isSelectionMode
                  ? () => context.read<ViewSlotsUiCubit>().toggleSlotSelection(
                    slot.slotId,
                  )
                  : null)
              : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.3) : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (uiState.isSelectionMode && slot.status == 'available') ...[
              Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                size: 18,
                color: color,
              ),
              const SizedBox(width: 8),
            ] else ...[
              Icon(
                slot.status == 'available'
                    ? Icons.check_circle_outline
                    : slot.status == 'booked'
                    ? Icons.person_outline
                    : Icons.block,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              '$displayStart - $displayEnd',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            if (!uiState.isSelectionMode &&
                slot.status == 'available' &&
                canEdit) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap:
                    () => showDialog(
                      context: context,
                      builder: (dialogContext) => EditSlotDialog(slot: slot),
                    ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child:  Icon(Icons.edit, size: 14, color: AppColors.gradientColor),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
