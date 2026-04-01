import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class NotificationSettingSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const NotificationSettingSectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text(subtitle,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}