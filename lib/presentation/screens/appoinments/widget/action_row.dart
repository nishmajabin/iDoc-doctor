import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/completed_badge.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_button.dart';

class ActionRow extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const ActionRow({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CompletedBadge(),
        const SizedBox(width: 8),
        PrescriptionButton(appointment: appointment),
      ],
    );
  }
}
