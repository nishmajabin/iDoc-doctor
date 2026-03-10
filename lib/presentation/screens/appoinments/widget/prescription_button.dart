import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/prescription_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/view_prescription_screen.dart';


class PrescriptionButton extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const PrescriptionButton({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    // final hasPrescription = false; // subcollection now — always show write option

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // View prescription
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewPrescriptionScreen(
                appointmentId: appointment.appointmentId,
                patientName: appointment.patientName,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.visibility_outlined,
                    color: Color(0xFF0099CC), size: 14),
                SizedBox(width: 4),
                Text('View',
                    style: TextStyle(
                        color: Color(0xFF0099CC),
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Write new prescription
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  PrescriptionScreen(appointment: appointment),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D0D),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note_rounded,
                    color: Color(0xFF00D4FF), size: 15),
                SizedBox(width: 5),
                Text('Prescribe',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.1)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}