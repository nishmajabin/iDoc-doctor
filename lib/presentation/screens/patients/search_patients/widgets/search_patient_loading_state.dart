import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class SearchPatientLoadingState extends StatelessWidget {
  const SearchPatientLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
                strokeWidth: 3, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading appointments…',
            style: GoogleFonts.poppins(
                fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}