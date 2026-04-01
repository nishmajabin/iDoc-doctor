import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class EditProfileBioField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  const EditProfileBioField({required this.controller, required this.enabled, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.description_outlined,
                    color: AppColors.primary, size: 18),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TextFormField(
                controller: controller,
                enabled: enabled,
                maxLines: 5,
                minLines: 3,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Bio cannot be empty'
                    : null,
                style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: AppColors.textPrimary,
                    height: 1.6),
                decoration: InputDecoration(
                  labelText: 'Professional Bio',
                  hintText:
                      'Tell patients about your expertise, experience and approach...',
                  labelStyle: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500),
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.5),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  errorStyle: GoogleFonts.poppins(
                      fontSize: 10, color: AppColors.cancelled),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
