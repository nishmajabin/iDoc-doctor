import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appoinment_empty_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/date_header.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'appointment_card.dart';

class AppointmentListView extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;
  final bool isUpcoming;

  const AppointmentListView({
    required this.appointments,
    required this.isUpcoming,
    super.key
  });

  Map<DateTime, List<DoctorAppointmentModel>> _groupByDate(
      List<DoctorAppointmentModel> items) {
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
      return EmptyState(isUpcoming: isUpcoming);
    }

    final grouped = _groupByDate(appointments);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final date = grouped.keys.elementAt(index);
        final dayAppointments = grouped[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateHeader(date: date),
            ...dayAppointments.map(
              (a) => AppointmentCard(
                appointment: a,
                isUpcoming: isUpcoming,
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

