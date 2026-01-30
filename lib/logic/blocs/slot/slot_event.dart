import 'package:equatable/equatable.dart';

abstract class SlotEvent extends Equatable {
  const SlotEvent();
  
  @override
  List<Object?> get props => [];
}

class FetchSlotsByDateRangeEvent extends SlotEvent {
  final DateTime startDate;
  final DateTime endDate;

  const FetchSlotsByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class CreateSlotsForDateRangeEvent extends SlotEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final int intervalMinutes;
  final int breakTimeMinutes;

  const CreateSlotsForDateRangeEvent({
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.intervalMinutes,
    this.breakTimeMinutes = 0,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    startTime,
    endTime,
    intervalMinutes,
    breakTimeMinutes,
  ];
}

class DeleteSlotEvent extends SlotEvent {
  final String slotId;

  const DeleteSlotEvent(this.slotId);

  @override
  List<Object?> get props => [slotId];
}

class UpdateSlotEvent extends SlotEvent {
  final String slotId;
  final String startTime;
  final String endTime;

  const UpdateSlotEvent({
    required this.slotId,
    required this.startTime,
    required this.endTime,
  });

  @override
  List<Object?> get props => [slotId, startTime, endTime];
}

class BlockSlotEvent extends SlotEvent {
  final String slotId;

  const BlockSlotEvent(this.slotId);

  @override
  List<Object?> get props => [slotId];
}