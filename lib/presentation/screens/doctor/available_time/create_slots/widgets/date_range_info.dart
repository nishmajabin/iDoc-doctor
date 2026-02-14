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
    if (rangeStart == null) {
      return const SizedBox.shrink();
    }

    final endDate = rangeEnd ?? rangeStart!;
    final dayCount = endDate.difference(rangeStart!).inDays + 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildDateRangeCard(dayCount, endDate),
          if (hasExistingSlots) ...[
            const SizedBox(height: 12),
            _buildErrorMessage(),
          ],
        ],
      ),
    );
  }

  Widget _buildDateRangeCard(int dayCount, DateTime endDate) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D4FF), Color(0xFF0099CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.date_range, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Date Range',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MMM dd').format(rangeStart!)} - ${DateFormat('MMM dd, yyyy').format(endDate)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$dayCount day${dayCount > 1 ? 's' : ''} selected',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.6), width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.block, size: 22, color: Colors.red[800]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'ERROR: Some dates already have slots! You cannot create slots for dates that already have slots. Please choose different dates or delete existing slots first.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.red[900],
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}