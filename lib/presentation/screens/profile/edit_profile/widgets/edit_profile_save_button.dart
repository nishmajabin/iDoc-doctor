import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class EditProfileSaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onTap;
  const EditProfileSaveButton({required this.isSaving, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSaving ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSaving
                ? [
                    AppColors.gradientStart.withValues(alpha: 0.6),
                    AppColors.gradientEnd.withValues(alpha: 0.6),
                  ]
                : const [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSaving
              ? []
              : [
                  BoxShadow(
                    color: AppColors.gradientStart.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSaving)
               SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(
                    color: AppColors.gradientColor, strokeWidth: 2),
              )
            else
               Icon(Icons.check_rounded, color: AppColors.bgColor, size: 20),
            const SizedBox(width: 10),
            Text(
              isSaving ? 'Saving...' : 'Save Changes',
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bgColor,
                  letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}