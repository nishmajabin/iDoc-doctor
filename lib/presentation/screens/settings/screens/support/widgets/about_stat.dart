import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class HelpAboutStat extends StatelessWidget {
  final String value;
  final String label;
  const HelpAboutStat({required this.value, required this.label, super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
