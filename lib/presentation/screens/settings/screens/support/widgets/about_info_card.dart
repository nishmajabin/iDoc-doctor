import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/about_stat_row.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_row_with_bar.dart';

class HelpAboutInfoCard extends StatelessWidget {
  const HelpAboutInfoCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gradientColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelpAboutRowWithBar(label: 'About iDoc'),
          const SizedBox(height: 12),
          Text(
            'iDoc is a modern telemedicine platform that connects licensed doctors with patients across India. Our mission is to make quality healthcare accessible to everyone, anytime, anywhere.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.75,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          AboutStatRow(),
        ],
      ),
    );
  }
}
