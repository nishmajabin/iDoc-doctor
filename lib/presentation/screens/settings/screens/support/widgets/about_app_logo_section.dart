import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class AboutAppLogoSection extends StatelessWidget {
  const AboutAppLogoSection({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.gradientColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gradientColor.withValues(alpha: 0.25)),
            ),
            child:  Icon(
              Icons.medical_services_outlined,
              color: AppColors.gradientColor,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'iDoc',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.bgColor,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            'Doctor Side',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.bgColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gradientColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.gradientColor.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Text(
              'Version 1.0.0',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.bgColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
