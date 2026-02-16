import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/action_row.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/message_button.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/patient_avatar.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/time_badge.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;


  const AppointmentCard({required this.appointment, required this.isUpcoming, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            PatientAvatar(
              name: appointment.patientName,
              imageUrl: appointment.profileImageUrl,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.patientName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D0D0D),
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  isUpcoming
                      ? TimeBadge(time: appointment.startTime)
                      : ActionRow(appointment: appointment),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const MessageButton(),
          ],
        ),
      ),
    );
  }
}





