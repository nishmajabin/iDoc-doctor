import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/screen/prescription_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/screen/view_prescription_screen.dart';

class PrescriptionButton extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const PrescriptionButton({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // View prescription
        _PillBtn(
          label: 'View Rx',
          icon: Icons.visibility_outlined,
          textColor: const Color(0xFF0077B6),
          bgColor: const Color(0xFFE0F4FF),
          useGradient: false,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewPrescriptionScreen(
                appointmentId: appointment.appointmentId,
                patientName: appointment.patientName,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Write prescription
        _PillBtn(
          label: 'Prescribe',
          icon: Icons.edit_note_rounded,
          textColor: Colors.white,
          bgColor: null,
          useGradient: true,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PrescriptionScreen(appointment: appointment),
            ),
          ),
        ),
      ],
    );
  }
}

class _PillBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color textColor;
  final Color? bgColor;
  final bool useGradient;
  final VoidCallback onTap;

  const _PillBtn({
    required this.label,
    required this.icon,
    required this.textColor,
    required this.bgColor,
    required this.useGradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          gradient: useGradient
              ? const LinearGradient(
                  colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: useGradient ? null : bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: useGradient
              ? [
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 14),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: textColor,
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
}