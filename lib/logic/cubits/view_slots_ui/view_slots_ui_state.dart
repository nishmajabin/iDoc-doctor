
import 'package:table_calendar/table_calendar.dart';

class ViewSlotsUiState {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final CalendarFormat calendarFormat;
  final bool isSelectionMode;
  final Set<String> selectedSlotIds;

  ViewSlotsUiState({
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.isSelectionMode,
    required this.selectedSlotIds,
  });

  ViewSlotsUiState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    CalendarFormat? calendarFormat,
    bool? isSelectionMode,
    Set<String>? selectedSlotIds,
  }) {
    return ViewSlotsUiState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedSlotIds: selectedSlotIds ?? this.selectedSlotIds,
    );
  }
}