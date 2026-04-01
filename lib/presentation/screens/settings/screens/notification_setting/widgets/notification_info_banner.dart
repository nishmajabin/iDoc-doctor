import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class NotificationInfoBanner extends StatelessWidget {
  const NotificationInfoBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Notification preferences are stored locally. System-level permissions must be granted from your device settings.',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                color: AppColors.primary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
