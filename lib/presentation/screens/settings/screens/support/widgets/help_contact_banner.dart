import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class HelpContactBanner extends StatelessWidget {
  const HelpContactBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('We\'re here to help',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bgColor)),
                const SizedBox(height: 4),
                Text('Our support team is ready\nto assist you anytime.',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color:AppColors.bgColor.withValues(alpha: 0.8),
                        height: 1.5)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child:  Icon(Icons.support_agent_rounded,
                color: AppColors.bgColor, size: 32),
          ),
        ],
      ),
    );
  }
}
