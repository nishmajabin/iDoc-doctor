import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';

String resolveStatus(DoctorAppointmentModel a) {
  if (a.status.toLowerCase() == 'completed') return 'completed';
  if (a.status.toLowerCase() == 'cancelled') return 'cancelled';
  try {
    final parts = a.endTime.split(':');
    final end = DateTime(
      a.appointmentDate.year,
      a.appointmentDate.month,
      a.appointmentDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    if (end.isBefore(DateTime.now())) return 'completed';
  } catch (_) {}
  return a.status.toLowerCase();
}

String formatTime(String t) {
  try {
    final p = t.split(':');
    int h = int.parse(p[0]);
    final m = int.parse(p[1]);
    final ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
  } catch (_) {
    return t;
  }
}

String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${months[d.month - 1]} ${d.day}, ${d.year}';
}

String initials(String name) {
  final parts = name.trim().split(' ');
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}
