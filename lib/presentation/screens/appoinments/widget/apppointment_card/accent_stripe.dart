import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';

class AccentStripe extends StatelessWidget {
  final bool isUpcoming;
  final DoctorAppointmentModel appointment;

  const AccentStripe({required this.isUpcoming, required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> colors;
    if (!isUpcoming) {
      final status = (appointment.status ?? 'completed').toLowerCase();
      colors = switch (status) {
        'cancelled' => [
            const Color(0xFFD13D3D).withOpacity(0.5),
            const Color(0xFFD13D3D).withOpacity(0.2),
          ],
        _ => [
            const Color(0xFF2D9E6B).withOpacity(0.6),
            const Color(0xFF2D9E6B).withOpacity(0.2),
          ],
      };
    } else {
      colors = [const Color(0xFF052C40), const Color(0xFF00B4D8)];
    }

    return Container(
      height: 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
    );
  }
}
