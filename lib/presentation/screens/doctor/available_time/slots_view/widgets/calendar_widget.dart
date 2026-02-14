import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  final ViewSlotsUiState uiState;
  final Map<DateTime, List<SlotModel>> slotsCache;

  const CalendarWidget({required this.uiState, required this.slotsCache, super.key});

  void _fetchSlotsForMonth(BuildContext context, DateTime focusedDay) {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    context.read<SlotBloc>().add(
      FetchSlotsByDateRangeEvent(startDate: firstDay, endDate: lastDay),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: uiState.focusedDay,
        selectedDayPredicate: (day) => isSameDay(uiState.selectedDay, day),
        calendarFormat: uiState.calendarFormat,
        startingDayOfWeek: StartingDayOfWeek.monday,
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          formatButtonTextStyle: const TextStyle(fontSize: 12),
          formatButtonDecoration: BoxDecoration(
            color: const Color(0xFF00D4FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
        ),
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF00D4FF),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: const TextStyle(color: Colors.black87),
          weekendTextStyle: const TextStyle(color: Colors.black54),
          markerDecoration: const BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
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
        onFormatChanged: (format) {
          context.read<ViewSlotsUiCubit>().updateCalendarFormat(format);
        },
        eventLoader: (day) {
          final normalizedDay = DateTime(day.year, day.month, day.day);
          return slotsCache[normalizedDay] ?? [];
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
      ),
    );
  }
}
