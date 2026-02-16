import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/widgets/status_config.dart';
import 'package:intl/intl.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'common_widgets.dart';

class HeroHeader extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final String displayStatus;
  final bool isPast;

  const HeroHeader({
    required this.appointment,
    required this.displayStatus,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = StatusConfig.from(displayStatus);

    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GlassButton(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.blurBackground],
        background: _HeaderBackground(
          appointment: appointment,
          statusConfig: statusConfig,
          isPast: isPast,
        ),
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final StatusConfig statusConfig;
  final bool isPast;

  const _HeaderBackground({
    required this.appointment,
    required this.statusConfig,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isPast
                      ? [const Color(0xFF2C3E50), const Color(0xFF4A5568)]
                      : [const Color(0xFF0077B6), const Color(0xFF00B4D8)],
            ),
          ),
        ),
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          left: -30,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    backgroundImage:
                        appointment.profileImageUrl != null &&
                                appointment.profileImageUrl!.isNotEmpty
                            ? NetworkImage(appointment.profileImageUrl!)
                            : null,
                    child:
                        appointment.profileImageUrl == null ||
                                appointment.profileImageUrl!.isEmpty
                            ? Text(
                              _getInitials(appointment.patientName),
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  appointment.patientName,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusConfig.color.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: statusConfig.color.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: statusConfig.color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        statusConfig.label,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    DateFormat(
                      'EEEE, MMM d · y',
                    ).format(appointment.appointmentDate),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
