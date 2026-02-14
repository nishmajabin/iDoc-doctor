import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';

class SlotCreationHelper {
  static void createSlots({
    required BuildContext context,
    required SlotBloc slotBloc,
    required DateTime? rangeStart,
    required DateTime? rangeEnd,
    required TimeOfDay? startTime,
    required TimeOfDay? endTime,
    required int selectedInterval,
    required int selectedBreakTime,
    required bool Function(DateTime, DateTime) checkExistingSlots,
  }) {
    if (rangeStart == null || startTime == null || endTime == null) {
      return;
    }

    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    
    if (endMinutes <= startMinutes) {
      _showErrorSnackbar(
        context,
        'End time must be after start time',
      );
      return;
    }

    final endDate = rangeEnd ?? rangeStart;
    final hasExisting = checkExistingSlots(rangeStart, endDate);
    
    if (hasExisting) {
      _showErrorSnackbar(
        context,
        'Cannot create slots - some dates already have slots!',
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final startTimeStr = _formatTime(startTime);
    final endTimeStr = _formatTime(endTime);

    slotBloc.add(
      CreateSlotsForDateRangeEvent(
        startDate: rangeStart,
        endDate: endDate,
        startTime: startTimeStr,
        endTime: endTimeStr,
        intervalMinutes: selectedInterval,
        breakTimeMinutes: selectedBreakTime,
      ),
    );
  }

  static String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  static void _showErrorSnackbar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: duration,
      ),
    );
  }

  static void showSuccessSnackbar(BuildContext context, int slotsCount) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$slotsCount slots created successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    _showErrorSnackbar(context, message, duration: const Duration(seconds: 3));
  }

  static void fetchSlotsForMonth(SlotBloc slotBloc, DateTime focusedDay) {
    final firstDay = DateTime(focusedDay.year, focusedDay.month, 1);
    final lastDay = DateTime(focusedDay.year, focusedDay.month + 1, 0);
    
    slotBloc.add(
      FetchSlotsByDateRangeEvent(startDate: firstDay, endDate: lastDay),
    );
  }
}