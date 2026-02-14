String formatTimeToAmPm(String time24) {
  try {
    final parts = time24.split(':');
    if (parts.length != 2) return time24;

    int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    final String period = hour >= 12 ? 'PM' : 'AM';

    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }

    final String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  } catch (_) {
    return time24;
  }
}

double getHoursSinceCreation(DateTime createdAt) {
  final difference = DateTime.now().difference(createdAt);
  return difference.inMinutes / 60.0;
}
