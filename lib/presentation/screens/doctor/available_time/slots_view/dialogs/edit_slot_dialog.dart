import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/slot_model.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_event.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/edit_slot/edit_slot_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/slot/edit_slot/edit_slot_state.dart';
import 'package:idoc_doctor_side/core/utils/time_formatter.dart';
import 'package:idoc_doctor_side/core/utils/time_utils.dart';
import 'package:intl/intl.dart';

// ── Entry point ──────────────────────────────────────────────────────────────

class EditSlotDialog extends StatelessWidget {
  final SlotModel slot;

  const EditSlotDialog({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditSlotCubit(
        initialStart: TimeFormatter.toTimeOfDay(slot.startTime),
        initialEnd: TimeFormatter.toTimeOfDay(slot.endTime),
      ),
      child: _EditSlotSheet(slot: slot),
    );
  }
}

// ── Bottom sheet body ────────────────────────────────────────────────────────

class _EditSlotSheet extends StatelessWidget {
  final SlotModel slot;

  const _EditSlotSheet({required this.slot});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: BlocBuilder<EditSlotCubit, EditSlotState>(
        builder: (context, state) {
          final startMin = state.startTime.hour * 60 + state.startTime.minute;
          final endMin = state.endTime.hour * 60 + state.endTime.minute;
          final isValid = endMin > startMin;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.edit_calendar_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Slot Time',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2332),
                          ),
                        ),
                        Text(
                          'Available within 1 hour of creation',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9DAFC2),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F8FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: Color(0xFF6B7A91),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                // Slot info card
                _buildInfoCard(context),
                const SizedBox(height: 20),
                // Time pickers
                Row(
                  children: [
                    Expanded(
                      child: _TimePickerField(
                        label: 'Start Time',
                        time: state.startTime,
                        icon: Icons.wb_sunny_outlined,
                        accentColor: const Color(0xFF0077B6),
                        onTap: () => _pickTime(
                          context,
                          state.startTime,
                          (t) => context
                              .read<EditSlotCubit>()
                              .updateStartTime(t),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F4FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _TimePickerField(
                        label: 'End Time',
                        time: state.endTime,
                        icon: Icons.nights_stay_outlined,
                        accentColor: const Color(0xFF00B4D8),
                        onTap: () => _pickTime(
                          context,
                          state.endTime,
                          (t) =>
                              context.read<EditSlotCubit>().updateEndTime(t),
                        ),
                      ),
                    ),
                  ],
                ),
                // Validation message
                if (!isValid) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEB),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFD13D3D).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            size: 14, color: Color(0xFFD13D3D)),
                        SizedBox(width: 7),
                        Text(
                          'End time must be after start time',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD13D3D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F8FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6B7A91),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: isValid ? () => _save(context, state) : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            gradient: isValid
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF052C40),
                                      Color(0xFF0077B6),
                                    ],
                                  )
                                : null,
                            color: isValid ? null : const Color(0xFFE8EEF4),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isValid
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF0077B6)
                                          .withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Update Slot',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isValid
                                  ? Colors.white
                                  : const Color(0xFFADB8C9),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final remainingMinutes =
        (60 - getHoursSinceCreation(slot.createdAt) * 60)
            .clamp(0, 60)
            .toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0077B6).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: DateFormat('MMM dd, yyyy').format(slot.date),
            color: const Color(0xFF0077B6),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.schedule_rounded,
            label: 'Created',
            value: DateFormat('MMM dd · HH:mm').format(slot.createdAt),
            color: const Color(0xFF0077B6),
          ),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.timer_rounded,
            label: 'Edit window',
            value: '$remainingMinutes min remaining',
            color: int.parse(remainingMinutes) <= 10
                ? const Color(0xFFE07B00)
                : const Color(0xFF2D9E6B),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    TimeOfDay initial,
    ValueChanged<TimeOfDay> onPicked,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0077B6),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  void _save(BuildContext context, EditSlotState state) {
    context.read<SlotBloc>().add(
      UpdateSlotEvent(
        slotId: slot.slotId,
        startTime: TimeFormatter.to24HourString(state.startTime),
        endTime: TimeFormatter.to24HourString(state.endTime),
      ),
    );
    Navigator.pop(context);
  }
}

// ── Reusable sub-widgets ─────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7A91),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _TimePickerField({
    required this.label,
    required this.time,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: accentColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: accentColor),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              time.format(context),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A2332),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}