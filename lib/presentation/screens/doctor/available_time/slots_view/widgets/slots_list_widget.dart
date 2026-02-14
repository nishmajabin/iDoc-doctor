import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'slot_chip_widget.dart';

class SlotsListWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const SlotsListWidget({required this.uiState, required this.slotsCache});

  @override
  Widget build(BuildContext context) {
    final normalizedDay = DateTime(
      uiState.selectedDay.year,
      uiState.selectedDay.month,
      uiState.selectedDay.day,
    );
    final slots = slotsCache[normalizedDay] ?? [];

    if (slots.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                'No slots for this date',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final availableSlots = slots.where((s) => s.status == 'available').toList();
    final bookedSlots = slots.where((s) => s.status == 'booked').toList();
    final blockedSlots = slots.where((s) => s.status == 'blocked').toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (availableSlots.isNotEmpty)
            _buildSlotSection(
              context,
              'Available Slots',
              availableSlots,
              Colors.green,
              uiState,
            ),
          if (bookedSlots.isNotEmpty)
            _buildSlotSection(
              context,
              'Booked Slots',
              bookedSlots,
              Colors.blue,
              uiState,
            ),
          if (blockedSlots.isNotEmpty)
            _buildSlotSection(
              context,
              'Blocked Slots',
              blockedSlots,
              Colors.red,
              uiState,
            ),
        ],
      ),
    );
  }

  Widget _buildSlotSection(
    BuildContext context,
    String title,
    List<SlotModel> slots,
    Color color,
    ViewSlotsUiState uiState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${slots.length}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                slots
                    .map(
                      (slot) => SlotChipWidget(
                        slot: slot,
                        color: color,
                        uiState: uiState,
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
