import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';

class SlotFormState {
  final DateTime focusedDay;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int selectedInterval;
  final int selectedBreakTime;
  final Map<DateTime, List<SlotModel>> slotsCache;

  SlotFormState({
    required this.focusedDay,
    this.rangeStart,
    this.rangeEnd,
    this.startTime,
    this.endTime,
    this.selectedInterval = 15,
    this.selectedBreakTime = 0,
    Map<DateTime, List<SlotModel>>? slotsCache,
  }) : slotsCache = slotsCache ?? {};

  SlotFormState copyWith({
    DateTime? focusedDay,
    DateTime? rangeStart,
    DateTime? rangeEnd,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? selectedInterval,
    int? selectedBreakTime,
    Map<DateTime, List<SlotModel>>? slotsCache,
    bool clearRangeStart = false,
    bool clearRangeEnd = false,
    bool clearStartTime = false,
    bool clearEndTime = false,
  }) {
    return SlotFormState(
      focusedDay: focusedDay ?? this.focusedDay,
      rangeStart: clearRangeStart ? null : (rangeStart ?? this.rangeStart),
      rangeEnd: clearRangeEnd ? null : (rangeEnd ?? this.rangeEnd),
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
      selectedInterval: selectedInterval ?? this.selectedInterval,
      selectedBreakTime: selectedBreakTime ?? this.selectedBreakTime,
      slotsCache: slotsCache ?? this.slotsCache,
    );
  }

  bool checkExistingSlotsInRange(DateTime start, DateTime end) {
    DateTime current = start;
    while (current.isBefore(end.add(const Duration(days: 1)))) {
      final normalized = _normalizeDate(current);
      if (slotsCache.containsKey(normalized) && slotsCache[normalized]!.isNotEmpty) {
        return true;
      }
      current = current.add(const Duration(days: 1));
    }
    return false;
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}