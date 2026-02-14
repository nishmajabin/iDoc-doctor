import 'package:idoc_doctor_side/data/models/slot_model.dart';

abstract class SlotState {}

class SlotInitial extends SlotState {}

class SlotLoading extends SlotState {}

class SlotsFetchedSuccess extends SlotState {
  final List<SlotModel> slots;

  SlotsFetchedSuccess(this.slots);
}

class SlotsCreatedSuccess extends SlotState {
  final List<SlotModel> slots;

  SlotsCreatedSuccess(this.slots);
}

class SlotDeletedSuccess extends SlotState {}

class MultipleSlotsDeletedSuccess extends SlotState {
  final int count;

  MultipleSlotsDeletedSuccess(this.count);
}

class SlotUpdatedSuccess extends SlotState {}

class SlotBlockedSuccess extends SlotState {}

class SlotError extends SlotState {
  final String message;

  SlotError(this.message);
}