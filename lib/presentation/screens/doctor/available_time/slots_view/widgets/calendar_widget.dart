import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/view_slots_ui/view_slots_ui_state.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const CalendarWidget({
    required this.uiState,
    required this.slotsCache,
    super.key,
  });

  void _fetchSlotsForMonth(BuildContext context, DateTime focusedDay) {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    context.read<SlotBloc>().add(
      FetchSlotsByDateRangeEvent(startDate: firstDay, endDate: lastDay),
    );
  }

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
              _buildFormatToggle(context),
              _buildCalendar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormatToggle(BuildContext context) {
    final isMonthly = uiState.calendarFormat == CalendarFormat.month;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF2F8FF),
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEF2F7), width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month_outlined,
              size: 16, color: Color(0xFF0077B6)),
          const SizedBox(width: 8),
          Text(
            isMonthly ? 'Monthly view' : 'Weekly view',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7A91),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.read<ViewSlotsUiCubit>().updateCalendarFormat(
              isMonthly ? CalendarFormat.week : CalendarFormat.month,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF0077B6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isMonthly ? 'Switch to Week' : 'Switch to Month',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0077B6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now().subtract(const Duration(days: 365)),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: uiState.focusedDay,
      selectedDayPredicate: (day) => isSameDay(uiState.selectedDay, day),
      calendarFormat: uiState.calendarFormat,
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
          color: const Color(0xFF00B4D8).withOpacity(0.18),
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
        defaultTextStyle: const TextStyle(
          color: Color(0xFF1A2332),
          fontSize: 13,
        ),
        weekendTextStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 13,
        ),
        markersMaxCount: 1,
      ),
      onDaySelected: (selectedDay, focusedDay) {
        context.read<ViewSlotsUiCubit>().updateSelectedDay(selectedDay);
        context.read<ViewSlotsUiCubit>().updateFocusedDay(focusedDay);
      },
      onPageChanged: (focusedDay) {
        context.read<ViewSlotsUiCubit>().updateFocusedDay(focusedDay);
        _fetchSlotsForMonth(context, focusedDay);
      },
      onFormatChanged: (format) =>
          context.read<ViewSlotsUiCubit>().updateCalendarFormat(format),
      eventLoader: (day) {
        final normalizedDay = DateTime(day.year, day.month, day.day);
        return slotsCache[normalizedDay] ?? [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isEmpty) return null;
          // Show colored dot based on slot status mix
          final slots = events.whereType<SlotModel>().toList();
          final hasBooked = slots.any((s) => s.status == 'booked');
          final hasAvailable = slots.any((s) => s.status == 'available');
          final dotColor = hasBooked
              ? const Color(0xFF0077B6)
              : hasAvailable
                  ? const Color(0xFF2D9E6B)
                  : const Color(0xFFD13D3D);

          return Positioned(
            bottom: 3,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}