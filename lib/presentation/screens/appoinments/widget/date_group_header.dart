import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateGroupHeader extends StatelessWidget {
  final DateTime date;
  final int count;

  const DateGroupHeader({required this.date, required this.count, super.key});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == tomorrow) return 'Tomorrow';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('EEE, MMM dd').format(date);
  }

  bool get _isToday {
    final now = DateTime.now();
    return date == DateTime(now.year, now.month, now.day);
  }

  bool get _isTomorrow {
    final now = DateTime.now();
    final tomorrow =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return date == tomorrow;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              gradient: _isToday
                  ? const LinearGradient(
                      colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                    )
                  : null,
              color: _isToday
                  ? null
                  : _isTomorrow
                      ? const Color(0xFFFFF3E0)
                      : const Color(0xFFEEF2F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isToday)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  _label(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: _isToday
                        ? Colors.white
                        : _isTomorrow
                            ? const Color(0xFFE07B00)
                            : const Color(0xFF6B7A91),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0077B6),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 10),
              color: const Color(0xFFEEF2F7),
            ),
          ),
        ],
      ),
    );
  }
}
