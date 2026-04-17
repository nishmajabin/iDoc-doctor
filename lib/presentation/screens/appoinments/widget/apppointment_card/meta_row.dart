import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/appointment_info_chip.dart';

class MetaRow extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;

  const MetaRow({required this.appointment, required this.isUpcoming, super.key});

  String _formatTime(String raw) {
    try {
      final parts = raw.split(':');
      int h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final period = h >= 12 ? 'PM' : 'AM';
      if (h > 12) h -= 12;
      if (h == 0) h = 12;
      return '$h:${m.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return raw;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
    }
    return '${months[d.month - 1]} ${d.day}';
  }

  @override
  Widget build(BuildContext context) {
    final timeColor =
        isUpcoming ? const Color(0xFF0077B6) : const Color(0xFF6B7A91);
    final timeBg =
        isUpcoming ? const Color(0xFFE0F4FF) : const Color(0xFFF0F5FB);

    return Row(
      children: [
        AppointmentInfoChip(
          icon: Icons.schedule_rounded,
          label: _formatTime(appointment.startTime),
          color: timeColor,
          bgColor: timeBg,
        ),
        const SizedBox(width: 8),
        AppointmentInfoChip(
          icon: Icons.calendar_today_rounded,
          label: _formatDate(appointment.appointmentDate),
          color: const Color(0xFF6B7A91),
          bgColor: const Color(0xFFF0F5FB),
        ),
      ],
    );
  }
}
