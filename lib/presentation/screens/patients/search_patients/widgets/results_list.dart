import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/screen/patient_detail_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/search_patient_card.dart';

class ResultsList extends StatelessWidget {
  final List<DoctorAppointmentModel> results;
  final DoctorModel currentDoctor;

  const ResultsList({
    required this.results,
    required this.currentDoctor,
    super.key
  });

  void _navigateToPatientDetail(
      BuildContext context, DoctorAppointmentModel appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PatientDetailScreen(
          appointment:   appointment,
          currentDoctor: currentDoctor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity:  1.0,
      duration: const Duration(milliseconds: 300),
      curve:    Curves.easeOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Row(
              children: [
                Text(
                  '${results.length} result${results.length == 1 ? '' : 's'}',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary),
                ),
                const Spacer(),
                Text('Tap a card to view details',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              physics: const BouncingScrollPhysics(),
              itemCount: results.length,
              itemBuilder: (context, index) => SearchPatientCard(
                appointment: results[index],
                onTap: () =>
                    _navigateToPatientDetail(context, results[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}