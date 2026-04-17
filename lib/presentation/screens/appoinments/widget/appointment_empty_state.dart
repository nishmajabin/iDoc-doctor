import 'package:flutter/material.dart';

class AppointmentEmptyState extends StatelessWidget {
  final bool isUpcoming;

  const AppointmentEmptyState({required this.isUpcoming, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming ? Icons.upcoming_rounded : Icons.history_rounded,
                size: 42,
                color: const Color(0xFF0077B6),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              isUpcoming
                  ? 'No Upcoming Appointments'
                  : 'No Past Appointments',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              isUpcoming
                  ? 'Your upcoming scheduled appointments will appear here once patients book with you.'
                  : 'Completed and cancelled consultations will be shown here.',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7A91),
                height: 1.65,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}