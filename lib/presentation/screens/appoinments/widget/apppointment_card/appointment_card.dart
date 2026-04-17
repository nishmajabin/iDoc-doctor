import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/accent_stripe.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/appointment_patient_info_row.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/meta_row.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/past_actions.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/apppointment_card/upcoming_actions.dart';

class AppointmentCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final bool isUpcoming;
  final VoidCallback? onTap; // 👈 add this

  const AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
    this.onTap, // 👈 add this
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // 👈 handle tap
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF052C40)
                  .withOpacity(isUpcoming ? 0.07 : 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Column(
            children: [
              AccentStripe(isUpcoming: isUpcoming, appointment: appointment),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppointmentPatientInfoRow(
                      appointment: appointment,
                      isUpcoming: isUpcoming,
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: const Color(0xFFF0F5FB)),
                    const SizedBox(height: 12),
                    MetaRow(
                      appointment: appointment,
                      isUpcoming: isUpcoming,
                    ),
                    if (isUpcoming) ...[
                      const SizedBox(height: 12),
                      UpcomingActions(appointment: appointment),
                    ] else ...[
                      const SizedBox(height: 12),
                      PastActions(appointment: appointment),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}