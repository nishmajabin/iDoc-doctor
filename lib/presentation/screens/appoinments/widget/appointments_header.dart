import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/header_pill.dart';

class AppointmentsHeader extends StatelessWidget {
  final double topPadding;
  final DoctorAppointmentState state;

  const AppointmentsHeader({
    required this.topPadding,
    required this.state,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    int upcomingCount = 0;
    int todayCount = 0;

    if (state is DoctorAppointmentLoaded) {
      final loaded = state as DoctorAppointmentLoaded;
      upcomingCount = loaded.upcoming.length;
      final today = DateTime.now();
      todayCount = loaded.upcoming
          .where(
            (a) =>
                a.appointmentDate.year == today.year &&
                a.appointmentDate.month == today.month &&
                a.appointmentDate.day == today.day,
          )
          .length;
    }

    return Container(
      height: topPadding + 80,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF052C40),
            Color(0xFF0077B6),
            Color(0xFF00B4D8),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────────────────────────────
          Positioned(
            top: -28,
            right: -28,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.055),
              ),
            ),
          ),
          Positioned(
            top: topPadding - 10,
            right: 80,
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          // ── Content ───────────────────────────────────────────────────
          Positioned(
            top: topPadding + 14,
            left: 20,
            right: 20,
            child: Row(
              children: [
                // Title + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Appointments',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Manage your consultations',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.65),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Stats pill
                if (state is DoctorAppointmentLoaded) ...[
                  if (todayCount > 0)
                    HeaderPill(
                      icon: Icons.today_rounded,
                      label: '$todayCount today',
                      isAccent: true,
                    )
                  else if (upcomingCount > 0)
                    HeaderPill(
                      icon: Icons.calendar_month_rounded,
                      label: '$upcomingCount upcoming',
                      isAccent: false,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}