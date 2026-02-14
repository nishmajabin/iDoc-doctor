import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientDetailScreen extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const PatientDetailScreen({
    super.key,
    required this.appointment,
  });

  /// Determines the actual display status based on appointment time
  String _getDisplayStatus() {
    // If already completed or cancelled in DB, show that
    if (appointment.status.toLowerCase() == 'completed') {
      return 'completed';
    }
    if (appointment.status.toLowerCase() == 'cancelled') {
      return 'cancelled';
    }

    // Check if appointment time has passed
    final appointmentDateTime = _combineDateTime(
      appointment.appointmentDate,
      appointment.endTime, // Use end time to determine if appointment is truly finished
    );

    final now = DateTime.now();

    // If appointment end time has passed, it should show as "Completed"
    if (appointmentDateTime.isBefore(now)) {
      return 'completed';
    }

    // Otherwise show the actual status (confirmed, pending, etc.)
    return appointment.status.toLowerCase();
  }

  /// Combines date and time string into DateTime
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
    } catch (e) {
      return DateTime(date.year, date.month, date.day);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayStatus = _getDisplayStatus();

    return BlocListener<DoctorAppointmentBloc, DoctorAppointmentState>(
      listener: (context, state) {
        if (state is AppointmentActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          // Optionally refresh appointments here
          // context.read<DoctorAppointmentBloc>().add(FetchDoctorAppointments(doctorId: appointment.doctorId));
        } else if (state is DoctorAppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFB3E5FC),
        body: SafeArea(
          child: Column(
            children: [
              // ─── Header with back button ────────────────────────────
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black87,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Patient Details',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              // ─── Patient profile section ────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile picture
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: appointment.profileImageUrl != null &&
                                appointment.profileImageUrl!.isNotEmpty
                            ? NetworkImage(appointment.profileImageUrl!)
                            : null,
                        child: appointment.profileImageUrl == null ||
                                appointment.profileImageUrl!.isEmpty
                            ? Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey[500],
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      // Patient name
                      Text(
                        appointment.patientName,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      // Status badge - USING DYNAMIC STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(displayStatus),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusText(displayStatus),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Appointment details section ────────────────────────
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Information',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Day of Week
                        _buildDetailCard(
                          icon: Icons.today_outlined,
                          title: 'Day',
                          value: _formatDayOfWeek(appointment.appointmentDate),
                          iconColor: Colors.purple,
                        ),

                        // Full Date
                        _buildDetailCard(
                          icon: Icons.calendar_today_outlined,
                          title: 'Date',
                          value: _formatFullDate(appointment.appointmentDate),
                          iconColor: Colors.blue,
                        ),

                        // Appointment Time (Start - End)
                        _buildDetailCard(
                          icon: Icons.access_time_outlined,
                          title: 'Appointment Time',
                          value:
                              '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
                          iconColor: Colors.orange,
                        ),

                        // Contact number (with call functionality)
                        if (appointment.contactNumber.isNotEmpty)
                          _buildDetailCard(
                            icon: Icons.phone_outlined,
                            title: 'Contact Number',
                            value: appointment.contactNumber,
                            iconColor: Colors.green,
                            isClickable: true,
                            onTap: () => _makePhoneCall(
                              context,
                              appointment.contactNumber,
                            ),
                          ),

                        // Description / Reason for appointment
                        if (appointment.description.isNotEmpty)
                          _buildDescriptionCard(
                            icon: Icons.description_outlined,
                            title: 'Reason for Appointment',
                            value: appointment.description,
                            iconColor: Colors.teal,
                          ),

                        // Prescription (if exists)
                        if (appointment.prescription != null &&
                            appointment.prescription!.isNotEmpty)
                          _buildDescriptionCard(
                            icon: Icons.medical_services_outlined,
                            title: 'Prescription',
                            value: appointment.prescription!,
                            iconColor: Colors.red,
                          ),

                        const SizedBox(height: 20),

                        // Add/Update prescription button - HIDE FOR COMPLETED/CANCELLED (using dynamic status)
                        if (displayStatus != 'completed' &&
                            displayStatus != 'cancelled')
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _showPrescriptionDialog(context);
                              },
                              icon: const Icon(Icons.medical_services_outlined),
                              label: Text(
                                appointment.prescription == null ||
                                        appointment.prescription!.isEmpty
                                    ? 'Add Prescription'
                                    : 'Update Prescription',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF0288D1),
                                side: const BorderSide(
                                  color: Color(0xFF0288D1),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Detail card for single-line info ───────────────────────────────
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    bool isClickable = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isClickable ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (isClickable)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.phone_in_talk,
                  size: 22,
                  color: Colors.green[700],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Description card for multi-line info ───────────────────────────
  Widget _buildDescriptionCard({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 54),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Make phone call ────────────────────────────────────────────────
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    // Remove any non-digit characters except + (for international numbers)
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleanNumber.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid phone number',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final uri = Uri(scheme: 'tel', path: cleanNumber);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not launch phone dialer',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ─── Show prescription dialog ───────────────────────────────────────
  void _showPrescriptionDialog(BuildContext context) {
    final TextEditingController prescriptionController =
        TextEditingController(text: appointment.prescription ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          appointment.prescription == null || appointment.prescription!.isEmpty
              ? 'Add Prescription'
              : 'Update Prescription',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: prescriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter prescription details...',
            hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0288D1)),
            ),
          ),
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final prescription = prescriptionController.text.trim();
              
              if (prescription.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Please enter prescription details',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              // Add prescription using BLoC
              context.read<DoctorAppointmentBloc>().add(
                AddPrescriptionEvent(
                  appointmentId: appointment.appointmentId,
                  prescription: prescription,
                ),
              );
              
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0288D1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Utility functions ──────────────────────────────────────────────
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

  String _formatDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date); // e.g., "Monday"
  }

  String _formatFullDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date); // e.g., "February 2, 2026"
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.blue; // ✅ Blue for confirmed (upcoming)
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green; // ✅ Green for completed
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
}