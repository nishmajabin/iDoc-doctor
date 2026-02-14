import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/slot_model.dart';
import 'package:idoc_doctor_side/data/services/slot_service.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';

class SlotBloc extends Bloc<SlotEvent, SlotState> {
  final SlotService slotService;
  final String doctorId;

  // Tracks the last fetched range so we know what to re-fetch after mutations.
  DateTime? _lastFetchStart;
  DateTime? _lastFetchEnd;

  SlotBloc({
    required this.slotService,
    required this.doctorId,
  }) : super(SlotInitial()) {
    on<FetchSlotsByDateRangeEvent>(_onFetchSlotsByDateRange);
    on<CreateSlotsForDateRangeEvent>(_onCreateSlotsForDateRange);
    on<DeleteSlotEvent>(_onDeleteSlot);
    on<DeleteMultipleSlotsEvent>(_onDeleteMultipleSlots);
    on<UpdateSlotEvent>(_onUpdateSlot);
    on<BlockSlotEvent>(_onBlockSlot);
  }

  // ---------------------------------------------------------------------------
  // Fetch
  // ---------------------------------------------------------------------------

  Future<void> _onFetchSlotsByDateRange(
    FetchSlotsByDateRangeEvent event,
    Emitter<SlotState> emit,
  ) async {
    try {
      emit(SlotLoading());

      // Remember the range so mutations can re-fetch the same window.
      _lastFetchStart = event.startDate;
      _lastFetchEnd = event.endDate;

      final slots = await slotService.fetchSlotsByDateRange(
        doctorId: doctorId,
        startDate: event.startDate,
        endDate: event.endDate,
      );

      emit(SlotsFetchedSuccess(slots));
    } catch (e) {
      emit(SlotError('Failed to fetch slots: ${e.toString()}'));
    }
  }

  // ---------------------------------------------------------------------------
  // Create
  // ---------------------------------------------------------------------------

  Future<void> _onCreateSlotsForDateRange(
    CreateSlotsForDateRangeEvent event,
    Emitter<SlotState> emit,
  ) async {
    try {
      emit(SlotLoading());

      final slots = _generateSlots(
        startDate: event.startDate,
        endDate: event.endDate,
        startTime: event.startTime,
        endTime: event.endTime,
        intervalMinutes: event.intervalMinutes,
        breakTimeMinutes: event.breakTimeMinutes,
      );

      await slotService.createSlots(slots);

      emit(SlotsCreatedSuccess(slots));
    } catch (e) {
      emit(SlotError('Failed to create slots: ${e.toString()}'));
    }
  }

  // ---------------------------------------------------------------------------
  // Delete single
  // ---------------------------------------------------------------------------

  Future<void> _onDeleteSlot(
    DeleteSlotEvent event,
    Emitter<SlotState> emit,
  ) async {
    try {
      emit(SlotLoading());

      await slotService.deleteSlot(event.slotId);

      emit(SlotDeletedSuccess());
    } catch (e) {
      emit(SlotError('Failed to delete slot: ${e.toString()}'));
    }
  }

  // ---------------------------------------------------------------------------
  // Delete multiple
  // ---------------------------------------------------------------------------

  Future<void> _onDeleteMultipleSlots(
    DeleteMultipleSlotsEvent event,
    Emitter<SlotState> emit,
  ) async {
    try {
      emit(SlotLoading());

      for (final slotId in event.slotIds) {
        await slotService.deleteSlot(slotId);
      }

      emit(MultipleSlotsDeletedSuccess(event.slotIds.length));
    } catch (e) {
      emit(SlotError('Failed to delete slots: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSlot(
    UpdateSlotEvent event,
    Emitter<SlotState> emit,
  ) async {
    try {
      emit(SlotLoading());

      await slotService.updateSlot(
        slotId: event.slotId,
        startTime: event.startTime,
        endTime: event.endTime,
      );

      emit(SlotUpdatedSuccess());
      if (_lastFetchStart != null && _lastFetchEnd != null) {
        final updatedSlots = await slotService.fetchSlotsByDateRange(
          doctorId: doctorId,
          startDate: _lastFetchStart!,
          endDate: _lastFetchEnd!,
        );
        emit(SlotsFetchedSuccess(updatedSlots));
      }
    } catch (e) {
      emit(SlotError('Failed to update slot: ${e.toString()}'));
    }
  }

  // ---------------------------------------------------------------------------
  // Block
  // ---------------------------------------------------------------------------

  Future<void> _onBlockSlot(
    BlockSlotEvent event,
    Emitter<SlotState> emit,
  ) async {
    try {
      emit(SlotLoading());

      await slotService.blockSlot(event.slotId);

      emit(SlotBlockedSuccess());
    } catch (e) {
      emit(SlotError('Failed to block slot: ${e.toString()}'));
    }
  }

  // ---------------------------------------------------------------------------
  // Slot generation helper
  // ---------------------------------------------------------------------------

  List<SlotModel> _generateSlots({
    required DateTime startDate,
    required DateTime endDate,
    required String startTime,
    required String endTime,
    required int intervalMinutes,
    required int breakTimeMinutes,
  }) {
    final List<SlotModel> slots = [];

    final startTimeParts = startTime.split(':');
    final startHour = int.parse(startTimeParts[0]);
    final startMinute = int.parse(startTimeParts[1]);

    final endTimeParts = endTime.split(':');
    final endHour = int.parse(endTimeParts[0]);
    final endMinute = int.parse(endTimeParts[1]);

    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      int currentSlotStart = startMinutes;

      while (currentSlotStart + intervalMinutes <= endMinutes) {
        final slotStartHour = currentSlotStart ~/ 60;
        final slotStartMinute = currentSlotStart % 60;

        final slotEndTime = currentSlotStart + intervalMinutes;
        final slotEndHour = slotEndTime ~/ 60;
        final slotEndMinute = slotEndTime % 60;

        final slot = SlotModel(
          slotId: '',
          doctorId: doctorId,
          date: currentDate,
          startTime:
              '${slotStartHour.toString().padLeft(2, '0')}:${slotStartMinute.toString().padLeft(2, '0')}',
          endTime:
              '${slotEndHour.toString().padLeft(2, '0')}:${slotEndMinute.toString().padLeft(2, '0')}',
          status: 'available',
          createdAt: DateTime.now(),
        );

        slots.add(slot);
        currentSlotStart += intervalMinutes + breakTimeMinutes;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return slots;
  }
}