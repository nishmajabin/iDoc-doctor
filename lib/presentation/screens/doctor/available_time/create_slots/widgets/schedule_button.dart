import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_state.dart';

class ScheduleButtonWidget extends StatelessWidget {
  final SlotState state;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final bool hasExistingSlots;
  final VoidCallback onCreateSlots;

  const ScheduleButtonWidget({
    super.key,
    required this.state,
    required this.rangeStart,
    required this.rangeEnd,
    required this.startTime,
    required this.endTime,
    required this.hasExistingSlots,
    required this.onCreateSlots,
  });

  @override
  Widget build(BuildContext context) {
    final isValid = rangeStart != null && startTime != null && endTime != null;
    final endDate = rangeEnd ?? rangeStart;
    final dayCount = endDate != null ? endDate.difference(rangeStart!).inDays + 1 : 0;
    
    bool hasValidTimeRange = false;
    if (startTime != null && endTime != null) {
      final start = startTime!.hour * 60 + startTime!.minute;
      final end = endTime!.hour * 60 + endTime!.minute;
      hasValidTimeRange = end > start;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Column(
        children: [
          if (isValid && !hasValidTimeRange)
            _buildTimeValidationError(),
          _buildButton(
            isEnabled: isValid && hasValidTimeRange && !hasExistingSlots && state is! SlotLoading,
            isLoading: state is SlotLoading,
            buttonText: _getButtonText(hasExistingSlots, isValid, dayCount),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeValidationError() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 16, color: Colors.red[800]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'End time must be after start time',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required bool isEnabled,
    required bool isLoading,
    required String buttonText,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onCreateSlots : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00D4FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        disabledBackgroundColor: Colors.grey[300],
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              buttonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  String _getButtonText(bool hasExistingSlots, bool isValid, int dayCount) {
    if (hasExistingSlots) {
      return 'Cannot Create - Slots Already Exist';
    }
    if (isValid) {
      return 'Create Slots for $dayCount Day${dayCount > 1 ? 's' : ''}';
    }
    return 'Schedule';
  }
}