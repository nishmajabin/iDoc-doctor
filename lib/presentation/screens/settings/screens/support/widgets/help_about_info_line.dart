import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class HelpAboutInfoLine extends StatelessWidget {
  final String label;
  final String value;
  const HelpAboutInfoLine({required this.label, required this.value, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}