import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'package:intl/intl.dart';

class StatisticsWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const StatisticsWidget({
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

    final total = slots.length;
    final available = slots.where((s) => s.status == 'available').length;
    final booked = slots.where((s) => s.status == 'booked').length;
    final blocked = slots.where((s) => s.status == 'blocked').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF052C40), Color(0xFF0077B6)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0077B6).withOpacity(0.28),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE').format(uiState.selectedDay),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat('MMMM dd, yyyy').format(uiState.selectedDay),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_available_rounded,
                          color: Colors.white, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        '$total slot${total != 1 ? 's' : ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider line
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.12),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatPill(
                  count: available,
                  label: 'Available',
                  color: const Color(0xFF2D9E6B),
                  bgColor: const Color(0xFF2D9E6B),
                  icon: Icons.check_circle_outline_rounded,
                ),
                const SizedBox(width: 10),
                _StatPill(
                  count: booked,
                  label: 'Booked',
                  color: const Color(0xFF90E0EF),
                  bgColor: const Color(0xFF00B4D8),
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(width: 10),
                _StatPill(
                  count: blocked,
                  label: 'Blocked',
                  color: const Color(0xFFFFADAD),
                  bgColor: const Color(0xFFD13D3D),
                  icon: Icons.block_rounded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  final Color bgColor;
  final IconData icon;

  const _StatPill({
    required this.count,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 13, color: color),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}