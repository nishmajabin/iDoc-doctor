import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/prescription_dialog.dart';

class PrescriptionButton extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const PrescriptionButton({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPrescriptionDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_note_rounded, color: Color(0xFF00D4FF), size: 15),
            SizedBox(width: 5),
            Text(
              'Prescribe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPrescriptionDialog(BuildContext context) {
    final TextEditingController prescriptionController = TextEditingController(
      text: appointment.prescription ?? '',
    );

    showDialog(
      context: context,
      builder:
          (dialogContext) => PrescriptionDialog(
            appointment: appointment,
            controller: prescriptionController,
            blocContext: context,
          ),
    );
  }
}