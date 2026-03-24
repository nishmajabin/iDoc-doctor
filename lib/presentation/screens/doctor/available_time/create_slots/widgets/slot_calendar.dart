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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF052C40).withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              _buildLegend(),
              _buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F8FF),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFEEF2F7), width: 1),
        ),
      ),
      child: Row(
        children: [
          _LegendItem(
            color: const Color(0xFF0077B6),
            label: 'Selected',
          ),
          const SizedBox(width: 16),
          _LegendItem(
            color: const Color(0xFF00B4D8).withOpacity(0.25),
            label: 'In range',
            textColor: const Color(0xFF0077B6),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFE07B00),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Has slots',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
        ),
        weekendStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[400],
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1A2332),
          letterSpacing: 0.2,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left_rounded,
          color: Color(0xFF0077B6),
          size: 24,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF0077B6),
          size: 24,
        ),
        headerPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        cellMargin: const EdgeInsets.all(3),
        todayDecoration: BoxDecoration(
          color: const Color(0xFF00B4D8).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(
          color: Color(0xFF0077B6),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        selectedDecoration: const BoxDecoration(
          color: Color(0xFF0077B6),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        rangeStartDecoration: const BoxDecoration(
          color: Color(0xFF0077B6),
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: const BoxDecoration(
          color: Color(0xFF0077B6),
          shape: BoxShape.circle,
        ),
        rangeHighlightColor: const Color(0xFF00B4D8),
        withinRangeDecoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        withinRangeTextStyle: const TextStyle(
          color: Color(0xFF052C40),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        defaultTextStyle: const TextStyle(
          color: Color(0xFF1A2332),
          fontSize: 13,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 13,
        ),
        disabledTextStyle: TextStyle(
          color: Colors.grey[300],
          fontSize: 13,
        ),
        markerDecoration: const BoxDecoration(
          color: Color(0xFFE07B00),
          shape: BoxShape.circle,
        ),
        markersMaxCount: 1,
        markerSize: 6,
        markerMargin: const EdgeInsets.only(top: 1),
      ),
      onDaySelected: onDaySelected,
      onPageChanged: onPageChanged,
      eventLoader: (day) {
        final normalizedDay = normalizeDate(day);
        final slots = slotsCache[normalizedDay] ?? [];
        return slots.take(1).toList();
      },
      calendarBuilders: CalendarBuilders(
        rangeHighlightBuilder: (context, day, isWithinRange) {
          if (!isWithinRange) return null;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF00B4D8).withOpacity(0.12),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          return Positioned(
            bottom: 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFE07B00),
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final Color? textColor;

  const _LegendItem({
    required this.color,
    required this.label,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textColor ?? Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}