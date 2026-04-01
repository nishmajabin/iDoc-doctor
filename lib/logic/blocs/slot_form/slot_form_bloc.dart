import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_state.dart';

class SlotFormBloc extends Bloc<SlotFormEvent, SlotFormState> {
  SlotFormBloc() : super(SlotFormState(focusedDay: DateTime.now())) {
    on<InitializeSlotForm>(_onInitialize);
    on<UpdatedFocusedDay>(_onUpdatedFocusedDay);
    on<SelectDay>(_onSelectDay);
    on<ClearDateRange>(_onClearDateRange);
    on<UpdateStartTime>(_onUpdateStartTime);
    on<UpdateEndTime>(_onUpdateEndTime);
    on<UpdateInterval>(_onUpdateInterval);
    on<UpdateBreakTime>(_onUpdateBreakTime);
    on<UpdateSlotsCache>(_onUpdateSlotsCache);
  }

  void _onInitialize(InitializeSlotForm event, Emitter<SlotFormState> emit) {
    emit(SlotFormState(focusedDay: DateTime.now()));
  }

  void _onUpdatedFocusedDay(UpdatedFocusedDay event, Emitter<SlotFormState> emit) {
    emit(state.copyWith(focusedDay: event.focusedDay));
  }

  void _onSelectDay(SelectDay event, Emitter<SlotFormState> emit) {
    final selectedDay = event.selectedDay;
    
    if (selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 2)))) {
      return;
    }

    DateTime? newRangeStart = state.rangeStart;
    DateTime? newRangeEnd = state.rangeEnd;

    if (newRangeStart == null) {
      newRangeStart = selectedDay;
      newRangeEnd = null;
    } else if (newRangeEnd != null) {
      newRangeStart = selectedDay;
      newRangeEnd = null;
    } else if (selectedDay.isBefore(newRangeStart)) {
      newRangeEnd = newRangeStart;
      newRangeStart = selectedDay;
    } else if (selectedDay.year == newRangeStart.year &&
        selectedDay.month == newRangeStart.month &&
        selectedDay.day == newRangeStart.day) {
      newRangeEnd = null;
    } else {
      newRangeEnd = selectedDay;
    }

    emit(state.copyWith(
      focusedDay: event.focusedDay,
      rangeStart: newRangeStart,
      rangeEnd: newRangeEnd,
      clearRangeEnd: newRangeEnd == null,
    ));
  }

  void _onClearDateRange(ClearDateRange event, Emitter<SlotFormState> emit) {
    emit(state.copyWith(
      clearRangeStart: true,
      clearRangeEnd: true,
    ));
  }

  void _onUpdateStartTime(UpdateStartTime event, Emitter<SlotFormState> emit) {
    TimeOfDay? newEndTime = state.endTime;
    
    if (event.startTime != null && state.endTime != null) {
      final startMinutes = event.startTime!.hour * 60 + event.startTime!.minute;
      final endMinutes = state.endTime!.hour * 60 + state.endTime!.minute;
      if (endMinutes <= startMinutes) {
        newEndTime = null;
      }
    }

    emit(state.copyWith(
      startTime: event.startTime,
      endTime: newEndTime,
      clearEndTime: newEndTime == null && state.endTime != null,
    ));
  }

  void _onUpdateEndTime(UpdateEndTime event, Emitter<SlotFormState> emit) {
    emit(state.copyWith(endTime: event.endTime));
  }

  void _onUpdateInterval(UpdateInterval event, Emitter<SlotFormState> emit) {
    emit(state.copyWith(selectedInterval: event.interval));
  }

  void _onUpdateBreakTime(UpdateBreakTime event, Emitter<SlotFormState> emit) {
    emit(state.copyWith(selectedBreakTime: event.breakTime));
  }

  void _onUpdateSlotsCache(UpdateSlotsCache event, Emitter<SlotFormState> emit) {
    final Map<DateTime, List<SlotModel>> newCache = {};
    
    for (final slot in event.slots) {
      final normalizedDate = _normalizeDate(slot.date);
      newCache.putIfAbsent(normalizedDate, () => []).add(slot);
    }

    emit(state.copyWith(slotsCache: newCache));
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
