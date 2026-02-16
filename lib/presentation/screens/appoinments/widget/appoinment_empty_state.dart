
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final bool isUpcoming;

  const EmptyState({required this.isUpcoming, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUpcoming
                    ? Icons.calendar_month_outlined
                    : Icons.history_rounded,
                size: 48,
                color: const Color(0xFFBDBDBD),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isUpcoming
                  ? 'No Upcoming Appointments'
                  : 'No Past Appointments',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D0D0D),
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              isUpcoming
                  ? 'Your upcoming scheduled appointments will appear here.'
                  : 'Completed appointments will be shown here.',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9E9E9E),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}