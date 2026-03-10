import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/completed_badge.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_button.dart';

class ActionRow extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const ActionRow({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        const CompletedBadge(),
        PrescriptionButton(appointment: appointment),
      ],
    );
  }
}