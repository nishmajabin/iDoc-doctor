import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'widgets/header.dart';
import 'widgets/info_card.dart';
import 'widgets/text_content_card.dart';
import 'widgets/prescription_button.dart';
import 'widgets/chat_button.dart';
import 'widgets/common_widgets.dart';

class PatientDetailScreen extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  final DoctorModel currentDoctor; // ← added

  const PatientDetailScreen({
    super.key,
    required this.appointment,
    required this.currentDoctor, // ← added
  });

  String _getDisplayStatus() {
    if (appointment.status.toLowerCase() == 'completed') return 'completed';
    if (appointment.status.toLowerCase() == 'cancelled') return 'cancelled';

    final appointmentDateTime = _combineDateTime(
      appointment.appointmentDate,
      appointment.endTime,
    );

    if (appointmentDateTime.isBefore(DateTime.now())) return 'completed';
    return appointment.status.toLowerCase();
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

  @override
  Widget build(BuildContext context) {
    final displayStatus = _getDisplayStatus();
    final isPast =
        displayStatus == 'completed' || displayStatus == 'cancelled';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: BlocListener<DoctorAppointmentBloc, DoctorAppointmentState>(
        listener: (context, state) {
          if (state is AppointmentActionSuccess) {
            _showToast(context, state.message, isError: false);
          } else if (state is DoctorAppointmentError) {
            _showToast(context, state.message, isError: true);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.surface,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              HeroHeader(
                appointment: appointment,
                displayStatus: displayStatus,
                isPast: isPast,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionLabel(
                        label: isPast
                            ? 'Appointment Summary'
                            : 'Appointment Details',
                        icon: isPast
                            ? Icons.history_rounded
                            : Icons.event_note_rounded,
                      ),
                      const SizedBox(height: 16),
                      AppointmentInfoCard(appointment: appointment),
                      const SizedBox(height: 24),

                      if (appointment.description.isNotEmpty) ...[
                        SectionLabel(
                          label: 'Reason for Visit',
                          icon: Icons.notes_rounded,
                        ),
                        const SizedBox(height: 16),
                        TextContentCard(
                          content: appointment.description,
                          accentColor: const Color(0xFF00897B),
                        ),
                        const SizedBox(height: 24),
                      ],

                      if (appointment.prescription != null &&
                          appointment.prescription!.isNotEmpty) ...[
                        SectionLabel(
                          label: 'Prescription',
                          icon: Icons.medication_rounded,
                        ),
                        const SizedBox(height: 16),
                        TextContentCard(
                          content: appointment.prescription!,
                          accentColor: AppColors.cancelled,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // ── Action buttons ──────────────────────────────────
                      if (!isPast) ...[
                        // Chat button — always shown for active appointments
                        ChatButton(
                          appointment: appointment,
                          currentDoctor: currentDoctor,
                        ),
                        const SizedBox(height: 12),
                        PrescriptionButton(appointment: appointment),
                        const SizedBox(height: 40),
                      ] else ...[
                        // Past appointments: still allow chatting (e.g. follow-up)
                        ChatButton(
                          appointment: appointment,
                          currentDoctor: currentDoctor,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.cancelled : AppColors.completed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}