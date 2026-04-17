import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/appointment_status_badge.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/consultation_type_badge.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/patient_avatar.dart';

class AppointmentPatientInfoRow extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;

  const AppointmentPatientInfoRow({
    required this.appointment,
    required this.isUpcoming,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PatientAvatar(
          name: appointment.patientName,
          imageUrl: appointment.profileImageUrl,
          isUpcoming: isUpcoming,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.patientName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isUpcoming
                      ? const Color(0xFF1A2332)
                      : const Color(0xFF4A5568),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              ConsultationTypeBadge(
                type: 'Consultation',
                isUpcoming: isUpcoming,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        AppointmentStatusBadge(
          status: appointment.status ??
              (isUpcoming ? 'confirmed' : 'completed'),
        ),
      ],
    );
  }
}