import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_card.dart';
import 'package:intl/intl.dart';

class AppointmentListView extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;
  final bool isUpcoming;

  const AppointmentListView({
    required this.appointments,
    required this.isUpcoming,
    super.key,
  });

  Map<DateTime, List<DoctorAppointmentModel>> _groupByDate(
    List<DoctorAppointmentModel> items,
  ) {
    final Map<DateTime, List<DoctorAppointmentModel>> grouped = {};
    for (final a in items) {
      final date = DateTime(
        a.appointmentDate.year,
        a.appointmentDate.month,
        a.appointmentDate.day,
      );
      grouped.putIfAbsent(date, () => []).add(a);
    }
    for (final list in grouped.values) {
      list.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return _EmptyState(isUpcoming: isUpcoming);
    }

    final grouped = _groupByDate(appointments);
    final sortedDates = grouped.keys.toList()
      ..sort((a, b) => isUpcoming ? a.compareTo(b) : b.compareTo(a));

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayAppointments = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateGroupHeader(date: date, count: dayAppointments.length),
            ...dayAppointments.map(
              (a) => AppointmentCard(appointment: a, isUpcoming: isUpcoming),
            ),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}


class _DateGroupHeader extends StatelessWidget {
  final DateTime date;
  final int count;

  const _DateGroupHeader({required this.date, required this.count});

  String _label() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == tomorrow) return 'Tomorrow';
    if (date == yesterday) return 'Yesterday';
    return DateFormat('EEE, MMM dd').format(date);
  }

  bool get _isToday {
    final now = DateTime.now();
    return date == DateTime(now.year, now.month, now.day);
  }

  bool get _isTomorrow {
    final now = DateTime.now();
    final tomorrow =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    return date == tomorrow;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              gradient: _isToday
                  ? const LinearGradient(
                      colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                    )
                  : null,
              color: _isToday
                  ? null
                  : _isTomorrow
                      ? const Color(0xFFFFF3E0)
                      : const Color(0xFFEEF2F7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isToday)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  _label(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: _isToday
                        ? Colors.white
                        : _isTomorrow
                            ? const Color(0xFFE07B00)
                            : const Color(0xFF6B7A91),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF0077B6).withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0077B6),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 10),
              color: const Color(0xFFEEF2F7),
            ),
          ),
        ],
      ),
    );
  }
}


class _EmptyState extends StatelessWidget {
  final bool isUpcoming;

  const _EmptyState({required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming ? Icons.upcoming_rounded : Icons.history_rounded,
                size: 42,
                color: const Color(0xFF0077B6),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              isUpcoming
                  ? 'No Upcoming Appointments'
                  : 'No Past Appointments',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              isUpcoming
                  ? 'Your upcoming scheduled appointments will appear here once patients book with you.'
                  : 'Completed and cancelled consultations will be shown here.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7A91),
                height: 1.65,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}