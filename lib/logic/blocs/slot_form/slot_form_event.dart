import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';

abstract class SlotFormEvent {}

class InitializeSlotForm extends SlotFormEvent {}

class UpdatedFocusedDay extends SlotFormEvent {
  final DateTime focusedDay;
  UpdatedFocusedDay(this.focusedDay);
}

class SelectDay extends SlotFormEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;
  SelectDay(this.selectedDay, this.focusedDay);
}

class ClearDateRange extends SlotFormEvent {}

class UpdateStartTime extends SlotFormEvent {
  final TimeOfDay? startTime;
  UpdateStartTime(this.startTime);
}

class UpdateEndTime extends SlotFormEvent {
  final TimeOfDay? endTime;
  UpdateEndTime(this.endTime);
}

class UpdateInterval extends SlotFormEvent {
  final int interval;
  UpdateInterval(this.interval);
}

class UpdateBreakTime extends SlotFormEvent {
  final int breakTime;
  UpdateBreakTime(this.breakTime);
}

class UpdateSlotsCache extends SlotFormEvent {
  final List<SlotModel> slots;
  UpdateSlotsCache(this.slots);
}