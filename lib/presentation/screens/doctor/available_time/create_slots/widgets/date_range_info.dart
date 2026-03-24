import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeInfoWidget extends StatelessWidget {
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool hasExistingSlots;
  final VoidCallback onClear;

  const DateRangeInfoWidget({
    super.key,
    required this.rangeStart,
    required this.rangeEnd,
    required this.hasExistingSlots,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    if (rangeStart == null) return const SizedBox.shrink();

    final endDate = rangeEnd ?? rangeStart!;
    final dayCount = endDate.difference(rangeStart!).inDays + 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildRangeCard(dayCount, endDate),
          if (hasExistingSlots) ...[
            const SizedBox(height: 10),
            _buildConflictBanner(),
          ],
        ],
      ),
    );
  }

  Widget _buildRangeCard(int dayCount, DateTime endDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF00B4D8).withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.date_range_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayCount == 1
                      ? DateFormat('EEEE, MMM dd yyyy').format(rangeStart!)
                      : '${DateFormat('MMM dd').format(rangeStart!)}  →  ${DateFormat('MMM dd, yyyy').format(endDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF052C40),
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0077B6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$dayCount day${dayCount > 1 ? 's' : ''} selected',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF00B4D8).withOpacity(0.3),
                ),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Color(0xFF0077B6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD13D3D).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFD13D3D).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.block_rounded,
              size: 18,
              color: Color(0xFFD13D3D),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conflict Detected',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD13D3D),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Some selected dates already have slots. Delete existing slots or choose different dates.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B2020),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}