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

  bool get _hasValidTimeRange {
    if (startTime == null || endTime == null) return false;
    final s = startTime!.hour * 60 + startTime!.minute;
    final e = endTime!.hour * 60 + endTime!.minute;
    return e > s;
  }

  bool get _isFormComplete =>
      rangeStart != null && startTime != null && endTime != null;

  bool get _canCreate =>
      _isFormComplete &&
      _hasValidTimeRange &&
      !hasExistingSlots &&
      state is! SlotLoading;

  @override
  Widget build(BuildContext context) {
    final endDate = rangeEnd ?? rangeStart;
    final dayCount = endDate != null
        ? endDate.difference(rangeStart!).inDays + 1
        : 0;
    final isLoading = state is SlotLoading;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildChecklist(),
          const SizedBox(height: 16),
          _buildButton(isLoading, dayCount),
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEF2F7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF052C40).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Checklist',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF9DAFC2),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          _CheckItem(
            label: 'Date range selected',
            isDone: rangeStart != null,
          ),
          const SizedBox(height: 8),
          _CheckItem(
            label: 'Start & end time set',
            isDone: startTime != null && endTime != null,
          ),
          const SizedBox(height: 8),
          _CheckItem(
            label: 'Valid time range (end > start)',
            isDone: _hasValidTimeRange,
          ),
          const SizedBox(height: 8),
          _CheckItem(
            label: 'No conflicting slots',
            isDone: !hasExistingSlots,
            isBlocker: hasExistingSlots,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(bool isLoading, int dayCount) {
    return GestureDetector(
      onTap: _canCreate ? onCreateSlots : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: _canCreate
              ? const LinearGradient(
                  colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: _canCreate ? null : const Color(0xFFE8EEF4),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _canCreate
              ? [
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            else
              Icon(
                _canCreate
                    ? Icons.rocket_launch_rounded
                    : Icons.lock_outline_rounded,
                color: _canCreate ? Colors.white : const Color(0xFFADB8C9),
                size: 20,
              ),
            const SizedBox(width: 10),
            Text(
              isLoading
                  ? 'Creating slots...'
                  : _canCreate
                      ? 'Create Slots for $dayCount Day${dayCount > 1 ? 's' : ''}'
                      : hasExistingSlots
                          ? 'Resolve Conflicts First'
                          : 'Complete All Steps',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
                color: _canCreate ? Colors.white : const Color(0xFFADB8C9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String label;
  final bool isDone;
  final bool isBlocker;

  const _CheckItem({
    required this.label,
    required this.isDone,
    this.isBlocker = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color dotColor;
    final Color textColor;
    final IconData icon;

    if (isBlocker) {
      dotColor = const Color(0xFFD13D3D);
      textColor = const Color(0xFFD13D3D);
      icon = Icons.close_rounded;
    } else if (isDone) {
      dotColor = const Color(0xFF2D9E6B);
      textColor = const Color(0xFF1A2332);
      icon = Icons.check_rounded;
    } else {
      dotColor = const Color(0xFFADB8C9);
      textColor = const Color(0xFF9DAFC2);
      icon = Icons.radio_button_unchecked_rounded;
    }

    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: dotColor.withOpacity(isDone || isBlocker ? 0.12 : 0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 13, color: dotColor),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: textColor,
            fontWeight: isDone ? FontWeight.w500 : FontWeight.w400,
            decoration: isBlocker ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}