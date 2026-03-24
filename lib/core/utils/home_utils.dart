import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_event.dart';
import 'package:idoc_doctor_side/presentation/screens/home/see_all_patients_screen.dart';


String getFirstName(String fullName) {
  if (fullName.trim().isEmpty) return 'Doctor';
  return fullName.trim().split(' ').first;
}

String getInitials(String name) {
  final parts = name.trim().split(' ');
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

String formatTime(String t) {
  try {
    final p = t.split(':');
    int h = int.parse(p[0]);
    final m = int.parse(p[1]);
    final ampm = h >= 12 ? 'PM' : 'AM';
    h = h % 12;
    if (h == 0) h = 12;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
  } catch (_) {
    return t;
  }
}

String timeOfDayGreeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Morning';
  if (h < 17) return 'Afternoon';
  return 'Evening';
}


DateTime combineDateTime(DateTime date, String time) {
  try {
    final parts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  } catch (_) {
    return DateTime(date.year, date.month, date.day);
  }
}

void splitAppointments(
  List<DoctorAppointmentModel> source,
  List<DoctorAppointmentModel> todayQueue,
  List<DoctorAppointmentModel> upcoming,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = today.add(const Duration(days: 1));

  for (final appt in source) {
    final apptDay = DateTime(
      appt.appointmentDate.year,
      appt.appointmentDate.month,
      appt.appointmentDate.day,
    );

    if (apptDay == today) {
      final apptDateTime = combineDateTime(
        appt.appointmentDate,
        appt.startTime,
      );
      if (!apptDateTime.isBefore(now)) todayQueue.add(appt);
    } else if (!apptDay.isBefore(tomorrow)) {
      upcoming.add(appt);
    }
  }
}


void navigateToAllPatients(
  BuildContext context,
  List<DoctorAppointmentModel> appts,
  String title,
  DoctorModel doctor
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => SeeAllPatientsScreen(
        currentDoctor: doctor,
        appointments: appts,
        title: title,
      ),
    ),
  );
}

void showLogoutDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder:
        (dialogContext) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: AppColors.textPrimary,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<LogoutBloc>().add(const LogoutRequested());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Sign Out',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
  );
}
