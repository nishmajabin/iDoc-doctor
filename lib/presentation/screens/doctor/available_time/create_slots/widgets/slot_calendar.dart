import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:table_calendar/table_calendar.dart';

class SlotCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final Map<DateTime, List<SlotModel>> slotsCache;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final DateTime Function(DateTime) normalizeDate;

  const SlotCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.slotsCache,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.normalizeDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoHeader(),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF00D4FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Tap to select start date, tap again to select end date. Orange dots = slots already exist',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 1)),
      lastDay: DateTime.now().add(const Duration(days: 90)),
      focusedDay: focusedDay,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      rangeStartDay: rangeStart,
      rangeEndDay: rangeEnd,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF00D4FF),
          shape: BoxShape.circle,
        ),
        rangeStartDecoration: const BoxDecoration(
          color: Color(0xFF00D4FF),
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: const BoxDecoration(
          color: Color(0xFF00D4FF),
          shape: BoxShape.circle,
        ),
        rangeHighlightColor: const Color(0xFF00D4FF).withValues(alpha: 0.2),
        withinRangeDecoration: BoxDecoration(
          color: const Color(0xFF00D4FF).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(color: Colors.black87),
        weekendTextStyle: const TextStyle(color: Colors.black54),
        markerDecoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      eventLoader: (day) {
        final normalizedDay = normalizeDate(day);
        final slots = slotsCache[normalizedDay] ?? [];
        return slots.take(3).toList();
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          return Positioned(
            bottom: 1,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}