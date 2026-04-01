import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class AllPatientsHeader extends StatelessWidget {
  final String title;
  const AllPatientsHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.gradientColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gradientColor.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child:  Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.bgColor,
                size: 17,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppColors.bgColor,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
