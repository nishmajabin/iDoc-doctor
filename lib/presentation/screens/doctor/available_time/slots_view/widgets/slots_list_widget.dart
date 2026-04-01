import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_state.dart';
import 'slot_card_widget.dart';

class SlotsListWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const SlotsListWidget({
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

    if (slots.isEmpty) {
      return _buildEmptyState();
    }

    final available = slots.where((s) => s.status == 'available').toList();
    final booked = slots.where((s) => s.status == 'booked').toList();
    final blocked = slots.where((s) => s.status == 'blocked').toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (available.isNotEmpty) ...[
            _buildSectionHeader(
              label: 'Available',
              count: available.length,
              color: const Color(0xFF2D9E6B),
              bgColor: const Color(0xFFE8F8F1),
              icon: Icons.check_circle_outline_rounded,
            ),
            const SizedBox(height: 10),
            _buildSlotGrid(context, available, const Color(0xFF2D9E6B)),
            const SizedBox(height: 20),
          ],
          if (booked.isNotEmpty) ...[
            _buildSectionHeader(
              label: 'Booked',
              count: booked.length,
              color: const Color(0xFF0077B6),
              bgColor: const Color(0xFFE0F4FF),
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 10),
            _buildSlotGrid(context, booked, const Color(0xFF0077B6)),
            const SizedBox(height: 20),
          ],
          if (blocked.isNotEmpty) ...[
            _buildSectionHeader(
              label: 'Blocked',
              count: blocked.length,
              color: const Color(0xFFD13D3D),
              bgColor: const Color(0xFFFFEBEB),
              icon: Icons.block_rounded,
            ),
            const SizedBox(height: 10),
            _buildSlotGrid(context, blocked, const Color(0xFFD13D3D)),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String label,
    required int count,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.only(left: 12),
            color: const Color(0xFFEEF2F7),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotGrid(
    BuildContext context,
    List<SlotModel> slots,
    Color color,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots
          .map((slot) => SlotCardWidget(
                slot: slot,
                color: color,
                uiState: uiState,
              ))
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF052C40).withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F4FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.event_busy_rounded,
                size: 36,
                color: Color(0xFF0077B6),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Slots for This Day',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap a different date on the calendar,\nor create new slots for this day.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7A91),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}