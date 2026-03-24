import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'package:idoc_doctor_side/core/utils/time_utils.dart';
import '../dialogs/edit_slot_dialog.dart';

class SlotCardWidget extends StatelessWidget {
  final SlotModel slot;
  final Color color;
  final ViewSlotsUiState uiState;

  const SlotCardWidget({
    required this.slot,
    required this.color,
    required this.uiState,
    super.key,
  });

  bool get _canEdit {
    if (slot.status != 'available') return false;
    return DateTime.now().difference(slot.createdAt).inMinutes <= 60;
  }

  bool get _isSelectable => slot.status == 'available';
  bool get _isSelected => uiState.selectedSlotIds.contains(slot.slotId);

  int get _minutesSinceCreation =>
      DateTime.now().difference(slot.createdAt).inMinutes;

  int get _minutesUntilEditExpiry =>
      (60 - _minutesSinceCreation).clamp(0, 60);

  @override
  Widget build(BuildContext context) {
    final displayStart = formatTimeToAmPm(slot.startTime);
    final displayEnd = formatTimeToAmPm(slot.endTime);

    final isInSelectionMode = uiState.isSelectionMode;

    return GestureDetector(
      onTap: isInSelectionMode && _isSelectable
          ? () => context
              .read<ViewSlotsUiCubit>()
              .toggleSlotSelection(slot.slotId)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isSelected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isSelected ? color : color.withOpacity(0.25),
            width: _isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF052C40).withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selection checkbox OR status icon
                if (isInSelectionMode && _isSelectable)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _isSelected ? color : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isSelected ? color : const Color(0xFFADB8C9),
                        width: 1.5,
                      ),
                    ),
                    child: _isSelected
                        ? const Icon(Icons.check, size: 12, color: Colors.white)
                        : null,
                  )
                else
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _statusIcon,
                      size: 11,
                      color: color,
                    ),
                  ),
                const SizedBox(width: 8),
                // Times
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayStart,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2332),
                      ),
                    ),
                    Text(
                      displayEnd,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9DAFC2),
                      ),
                    ),
                  ],
                ),
                // Edit button (only for available + within 60 min + not in selection mode)
                if (!isInSelectionMode && slot.status == 'available') ...[
                  const SizedBox(width: 8),
                  _buildEditButton(context),
                ],
              ],
            ),
            // Edit expiry countdown (if close to expiry)
            if (_canEdit && _minutesUntilEditExpiry <= 15 && !isInSelectionMode) ...[
              const SizedBox(height: 6),
              _buildExpiryBadge(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    if (_canEdit) {
      return GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (_) => EditSlotDialog(slot: slot),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF052C40), Color(0xFF0077B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(Icons.edit_rounded, size: 11, color: Colors.white),
        ),
      );
    } else {
      // Edit window expired - show locked icon with tooltip
      return Tooltip(
        message: 'Edit window expired (> 1 hour after creation)',
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F8FF),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: const Color(0xFFDDE8F0)),
          ),
          child: const Icon(
            Icons.lock_outline_rounded,
            size: 11,
            color: Color(0xFFADB8C9),
          ),
        ),
      );
    }
  }

  Widget _buildExpiryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE07B00).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 10, color: Color(0xFFE07B00)),
          const SizedBox(width: 4),
          Text(
            'Edit expires in ${_minutesUntilEditExpiry}m',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE07B00),
            ),
          ),
        ],
      ),
    );
  }

  IconData get _statusIcon {
    switch (slot.status) {
      case 'available':
        return Icons.check_rounded;
      case 'booked':
        return Icons.person_rounded;
      case 'blocked':
        return Icons.block_rounded;
      default:
        return Icons.circle;
    }
  }
}