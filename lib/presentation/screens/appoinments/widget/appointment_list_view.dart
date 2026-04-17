import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_empty_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/appointment_card.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/date_group_header.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/screen/patient_detail_screen.dart';

class AppointmentListView extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;
  final DoctorModel currentDoctor; // ← keep this
  final bool isUpcoming;

  const AppointmentListView({
    required this.appointments,
    required this.isUpcoming,
    required this.currentDoctor, // ← ensure required
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
      return AppointmentEmptyState(isUpcoming: isUpcoming);
    }

    final grouped = _groupByDate(appointments);
    final sortedDates =
        grouped.keys.toList()
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
            DateGroupHeader(date: date, count: dayAppointments.length),
            ...dayAppointments.map(
              (a) => AppointmentCard(
                appointment: a,
                isUpcoming: isUpcoming,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PatientDetailScreen(
                            appointment: a,
                            currentDoctor: currentDoctor, // ← already correct
                          ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}
