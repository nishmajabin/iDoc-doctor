import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/view_slots_ui/view_slots_ui_state.dart';
import 'package:table_calendar/table_calendar.dart';

class ViewSlotsUiCubit extends Cubit<ViewSlotsUiState> {
  ViewSlotsUiCubit() : super(ViewSlotsUiState(
    focusedDay: DateTime.now(),
    selectedDay: DateTime.now(),
    calendarFormat: CalendarFormat.month,
    isSelectionMode: false,
    selectedSlotIds: {},
  ));

  void updateFocusedDay(DateTime day) {
    emit(state.copyWith(focusedDay: day));
  }

  void updateSelectedDay(DateTime day) {
    emit(state.copyWith(
      selectedDay: day,
      selectedSlotIds: {}, // Clear selections when changing date
    ));
  }

  void updateCalendarFormat(CalendarFormat format) {
    emit(state.copyWith(calendarFormat: format));
  }

  void toggleSelectionMode() {
    emit(state.copyWith(
      isSelectionMode: !state.isSelectionMode,
      selectedSlotIds: {}, // Clear selections when toggling mode
    ));
  }

  void toggleSlotSelection(String slotId) {
    final newSelectedIds = Set<String>.from(state.selectedSlotIds);
    if (newSelectedIds.contains(slotId)) {
      newSelectedIds.remove(slotId);
    } else {
      newSelectedIds.add(slotId);
    }
    emit(state.copyWith(selectedSlotIds: newSelectedIds));
  }

  void selectAllSlots(List<String> slotIds) {
    final newSelectedIds = Set<String>.from(state.selectedSlotIds);
    newSelectedIds.addAll(slotIds);
    emit(state.copyWith(selectedSlotIds: newSelectedIds));
  }

  void clearSelections() {
    emit(state.copyWith(selectedSlotIds: {}));
  }
}
