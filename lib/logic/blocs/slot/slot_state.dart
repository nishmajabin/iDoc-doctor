import 'package:equatable/equatable.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';

abstract class SlotState extends Equatable {
  const SlotState();
  
  @override
  List<Object?> get props => [];
}

class SlotInitial extends SlotState {
  const SlotInitial();
}

class SlotLoading extends SlotState {
  const SlotLoading();
}

class SlotsFetchedSuccess extends SlotState {
  final List<SlotModel> slots;

  const SlotsFetchedSuccess(this.slots);

  @override
  List<Object?> get props => [slots];
}

class SlotsCreatedSuccess extends SlotState {
  final List<SlotModel> slots;

  const SlotsCreatedSuccess(this.slots);

  @override
  List<Object?> get props => [slots];
}

class SlotDeletedSuccess extends SlotState {
  const SlotDeletedSuccess();
}

class SlotUpdatedSuccess extends SlotState {
  const SlotUpdatedSuccess();
}

class SlotBlockedSuccess extends SlotState {
  const SlotBlockedSuccess();
}

class SlotError extends SlotState {
  final String message;

  const SlotError(this.message);

  @override
  List<Object?> get props => [message];
}