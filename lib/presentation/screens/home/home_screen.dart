import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/presentation/patients/search_patients_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch once the bloc + auth are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAppointments();
    });
  }

  void _fetchAppointments() {
    final authState = context.read<DoctorAuthBloc>().state;
    if (authState is DoctorAuthSuccess) {
      context.read<DoctorAppointmentBloc>().add(
            FetchDoctorAppointments(authState.doctor.id!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3E5FC),
      body: SafeArea(
        child: BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
          builder: (context, authState) {
            String doctorName = 'Doctor';
            String? profileImageUrl;

            if (authState is DoctorAuthSuccess) {
              doctorName = authState.doctor.name;
              profileImageUrl = authState.doctor.profileImageUrl;
            }

            return Column(
              children: [
                // ─── Header ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        backgroundImage: profileImageUrl != null &&
                                profileImageUrl.isNotEmpty
                            ? NetworkImage(profileImageUrl)
                            : null,
                        child: profileImageUrl == null ||
                                profileImageUrl.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 28,
                                color: Colors.grey[600],
                              )
                            : null,
                      ),
                      Text(
                        'iDoc',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // ─── Welcome ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome ${_getFirstName(doctorName)}',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Have a Nice day',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ─── Search Bar (Clickable) ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to search screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPatientsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Text(
                            'Search patients....',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ─── White content panel ────────────────────────────────
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: BlocBuilder<DoctorAppointmentBloc,
                        DoctorAppointmentState>(
                      builder: (context, appointmentState) {
                        // ── derive the two lists ──────────────────────
                        final List<DoctorAppointmentModel> nextPatients = [];
                        final List<DoctorAppointmentModel> todayAppointments =
                            [];

                        if (appointmentState is DoctorAppointmentLoaded) {
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final tomorrow = today.add(const Duration(days: 1));

                          for (final appt in appointmentState.upcoming) {
                            final apptDate = DateTime(
                              appt.appointmentDate.year,
                              appt.appointmentDate.month,
                              appt.appointmentDate.day,
                            );

                            if (apptDate == today) {
                              // Today + not yet passed → Next patient
                              final apptDateTime = _combineDateTime(
                                appt.appointmentDate,
                                appt.startTime,
                              );
                              if (apptDateTime.isAfter(now) ||
                                  apptDateTime.isAtSameMomentAs(now)) {
                                nextPatients.add(appt);
                              }
                            } else if (!apptDate.isBefore(tomorrow)) {
                              // Tomorrow onwards → Appointments
                              todayAppointments.add(appt);
                            }
                          }
                        }
                        final isLoading =
                            appointmentState is DoctorAppointmentLoading;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Next patient Header with See All ──────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Next patient',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (!isLoading && nextPatients.isNotEmpty)
                                    GestureDetector(
                                      onTap: () => _navigateToAllPatients(
                                        context,
                                        nextPatients,
                                        'Today\'s Patients',
                                      ),
                                      child: Text(
                                        'See All',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF0288D1),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (isLoading)
                                _buildShimmerHorizontalGrid()
                              else if (nextPatients.isEmpty)
                                _buildEmptyState(
                                  icon: Icons.calendar_today_outlined,
                                  message: 'No upcoming patients',
                                )
                              else
                                _buildHorizontalPatientGrid(nextPatients),

                              const SizedBox(height: 32),

                              // ── Appointments Header with See All ──────
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Appointments',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  if (!isLoading &&
                                      todayAppointments.isNotEmpty)
                                    GestureDetector(
                                      onTap: () => _navigateToAllPatients(
                                        context,
                                        todayAppointments,
                                        'All Appointments',
                                      ),
                                      child: Text(
                                        'See All',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF0288D1),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              if (isLoading)
                                _buildShimmerHorizontalGrid()
                              else if (todayAppointments.isEmpty)
                                _buildEmptyState(
                                  icon: Icons.event_busy_outlined,
                                  message: 'No appointments scheduled',
                                )
                              else
                                _buildHorizontalPatientGrid(todayAppointments),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── Horizontal scrollable patient grid (max 6 items) ──────────────────
  Widget _buildHorizontalPatientGrid(
    List<DoctorAppointmentModel> appointments,
  ) {
    final displayedAppointments = appointments.take(6).toList();

    return SizedBox(
      height: 180, // Height for each card
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayedAppointments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < displayedAppointments.length - 1 ? 12 : 0,
            ),
            child: SizedBox(
              width: 160, // Width for each card
              child: _PatientCard(appointment: displayedAppointments[index]),
            ),
          );
        },
      ),
    );
  }

  // ─── Shimmer loading for horizontal grid ────────────────────────────────
  Widget _buildShimmerHorizontalGrid() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: index < 3 ? 12 : 0),
            child: SizedBox(
              width: 160,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile circle
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.grey[300],
                      ),
                      const SizedBox(height: 10),
                      // Name placeholder
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Time badge placeholder
                      Container(
                        width: 80,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Empty state placeholder ────────────────────────────────────────────
  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              message,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Navigate to See All screen ─────────────────────────────────────────
  void _navigateToAllPatients(
    BuildContext context,
    List<DoctorAppointmentModel> appointments,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AllPatientsScreen(appointments: appointments, title: title),
      ),
    );
  }

  // ─── Utility ────────────────────────────────────────────────────────────
  String _getFirstName(String fullName) {
    if (fullName.isEmpty) return 'Doctor';
    return fullName.trim().split(' ').first;
  }

  DateTime _combineDateTime(DateTime date, String time) {
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
}

// ═══════════════════════════════════════════════════════════════════════════
// Patient Card Widget – matches the screenshot design exactly
// ═══════════════════════════════════════════════════════════════════════════
class _PatientCard extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  const _PatientCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    final displayTime = _formatTime(appointment.startTime);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Profile photo ─────────────────────────────────────────
          CircleAvatar(
            radius: 38,
            backgroundColor: Colors.grey[200],
            backgroundImage: appointment.profileImageUrl != null &&
                    appointment.profileImageUrl!.isNotEmpty
                ? NetworkImage(appointment.profileImageUrl!)
                : null,
            child: appointment.profileImageUrl == null ||
                    appointment.profileImageUrl!.isEmpty
                ? Icon(Icons.person, size: 36, color: Colors.grey[500])
                : null,
          ),

          const SizedBox(height: 10),

          // ── Patient name ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              appointment.patientName,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),

          // ── Time badge (cyan pill like in screenshot) ─────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFB3E5FC), // same light-cyan as background
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  displayTime,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Converts "HH:mm" (24h) → "hh:mm AM/PM"
  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      int hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final ampm = hour >= 12 ? 'PM' : 'AM';
      hour = hour % 12;
      if (hour == 0) hour = 12;
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $ampm';
    } catch (_) {
      return time24;
    }
  }
}


class AllPatientsScreen extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;
  final String title;

  const AllPatientsScreen({
    super.key,
    required this.appointments,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3E5FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: appointments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy_outlined,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No appointments found',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return _PatientCard(appointment: appointments[index]);
              },
            ),
    );
  }
}