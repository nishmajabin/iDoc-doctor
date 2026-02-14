abstract class SlotEvent {}

class FetchSlotsByDateRangeEvent extends SlotEvent {
  final DateTime startDate;
  final DateTime endDate;

  FetchSlotsByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });
}

class CreateSlotsForDateRangeEvent extends SlotEvent {
  final DateTime startDate;
  final DateTime endDate;
  final String startTime;
  final String endTime;
  final int intervalMinutes;
  final int breakTimeMinutes;

  CreateSlotsForDateRangeEvent({
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.intervalMinutes,
    required this.breakTimeMinutes,
  });
}

class DeleteSlotEvent extends SlotEvent {
  final String slotId;

  DeleteSlotEvent(this.slotId);
}

class DeleteMultipleSlotsEvent extends SlotEvent {
  final List<String> slotIds;

  DeleteMultipleSlotsEvent(this.slotIds);
}

class UpdateSlotEvent extends SlotEvent {
  final String slotId;
  final String startTime;
  final String endTime;

  UpdateSlotEvent({
    required this.slotId,
    required this.startTime,
    required this.endTime,
  });
}

class BlockSlotEvent extends SlotEvent {
  final String slotId;

  BlockSlotEvent(this.slotId);
}
// Add this new event to your existing events
class RefreshSlotsEvent extends SlotEvent {
  final DateTime startDate;
  final DateTime endDate;
  
   RefreshSlotsEvent({
    required this.startDate,
    required this.endDate,
  });
  
  @override
  List<Object> get props => [startDate, endDate];
}