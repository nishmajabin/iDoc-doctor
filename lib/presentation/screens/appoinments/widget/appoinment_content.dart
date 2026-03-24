import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_loading_view.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/loading_view.dart';

class AppointmentsContent extends StatelessWidget {
  const AppointmentsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      body: BlocConsumer<DoctorAppointmentBloc, DoctorAppointmentState>(
        listener: (context, state) {
          if (state is DoctorAppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFD13D3D),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // ── Page body ───────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(top: topPadding + 80),
                child: _buildBody(state),
              ),

              // ── Fixed gradient header ───────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _AppointmentsHeader(
                  topPadding: topPadding,
                  state: state,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(DoctorAppointmentState state) {
    if (state is DoctorAppointmentLoading) {
      return const LoadingView();
    }
    if (state is DoctorAppointmentLoaded) {
      return AppointmentLoadingView(state: state);
    }
    return const SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gradient header
// ─────────────────────────────────────────────────────────────────────────────

class _AppointmentsHeader extends StatelessWidget {
  final double topPadding;
  final DoctorAppointmentState state;

  const _AppointmentsHeader({
    required this.topPadding,
    required this.state,
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
                    _HeaderPill(
                      icon: Icons.today_rounded,
                      label: '$todayCount today',
                      isAccent: true,
                    )
                  else if (upcomingCount > 0)
                    _HeaderPill(
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

class _HeaderPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isAccent;

  const _HeaderPill({
    required this.icon,
    required this.label,
    required this.isAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: isAccent
            ? Colors.white.withOpacity(0.22)
            : Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(isAccent ? 0.4 : 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}