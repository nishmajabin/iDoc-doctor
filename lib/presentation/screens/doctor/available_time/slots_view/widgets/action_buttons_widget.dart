import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_state.dart';
import 'package:intl/intl.dart';

class ActionButtonsWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const ActionButtonsWidget({
    required this.uiState,
    required this.slotsCache,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedDay = DateTime(
      uiState.selectedDay.year,
      uiState.selectedDay.month,
      uiState.selectedDay.day,
    );
    final slots = slotsCache[normalizedDay] ?? [];
    final availableSlots =
        slots.where((s) => s.status == 'available').toList();

    if (availableSlots.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              // Select slots toggle
              Expanded(
                child: _ActionButton(
                  label: uiState.isSelectionMode ? 'Cancel Select' : 'Select Slots',
                  icon: uiState.isSelectionMode
                      ? Icons.close_rounded
                      : Icons.check_box_outline_blank_rounded,
                  accentColor: const Color(0xFF0077B6),
                  onTap: () =>
                      context.read<ViewSlotsUiCubit>().toggleSelectionMode(),
                ),
              ),
              const SizedBox(width: 10),
              // Select all (only in selection mode)
              if (uiState.isSelectionMode)
                Expanded(
                  child: _ActionButton(
                    label: 'Select All',
                    icon: Icons.select_all_rounded,
                    accentColor: const Color(0xFF00B4D8),
                    onTap: () {
                      final slotIds =
                          availableSlots.map((s) => s.slotId).toList();
                      context
                          .read<ViewSlotsUiCubit>()
                          .selectAllSlots(slotIds);
                    },
                  ),
                )
              else
                // Delete all (not in selection mode)
                Expanded(
                  child: _ActionButton(
                    label: 'Delete All',
                    icon: Icons.delete_sweep_rounded,
                    accentColor: const Color(0xFFD13D3D),
                    onTap: () => _showDeleteAllDialog(
                      context,
                      availableSlots,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(
    BuildContext context,
    List<SlotModel> availableSlots,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_sweep_rounded,
                    color: Color(0xFFD13D3D), size: 28),
              ),
              const SizedBox(height: 18),
              const Text(
                'Delete All Available Slots?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A2332),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This will delete all ${availableSlots.length} available slot${availableSlots.length > 1 ? 's' : ''} for ${DateFormat('MMM dd, yyyy').format(uiState.selectedDay)}.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7A91),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7A91),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<SlotBloc>().add(
                          DeleteMultipleSlotsEvent(
                            availableSlots.map((s) => s.slotId).toList(),
                          ),
                        );
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD13D3D),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Delete All',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: 16),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}