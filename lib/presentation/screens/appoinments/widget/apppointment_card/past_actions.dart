import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_button.dart';

class PastActions extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const PastActions({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    final isCancelled =
        (appointment.status ?? '').toLowerCase() == 'cancelled';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: isCancelled
                ? const Color(0xFFFFEBEB)
                : const Color(0xFFE8F8F1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCancelled
                  ? const Color(0xFFD13D3D).withOpacity(0.25)
                  : const Color(0xFF2D9E6B).withOpacity(0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCancelled
                    ? Icons.cancel_outlined
                    : Icons.task_alt_rounded,
                size: 13,
                color: isCancelled
                    ? const Color(0xFFD13D3D)
                    : const Color(0xFF2D9E6B),
              ),
              const SizedBox(width: 5),
              Text(
                isCancelled ? 'Cancelled' : 'Completed',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isCancelled
                      ? const Color(0xFFD13D3D)
                      : const Color(0xFF2D9E6B),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        if (!isCancelled) PrescriptionButton(appointment: appointment),
      ],
    );
  }
}