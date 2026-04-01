import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/utils/home_utils.dart';

class DoctorAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  const DoctorAvatar({required this.imageUrl, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return Container(
    
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gradientColor.withValues(alpha: 0.25),
        image:
            hasImage
                ? DecorationImage(
                  image: NetworkImage(imageUrl!),
                  fit: BoxFit.cover,
                )
                : null,
        border: Border.all(color: AppColors.gradientColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child:
          hasImage
              ? null
              : Center(
                child: Text(
                  getInitials(name),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.bgColor,
                  ),
                ),
              ),
    );
  }
}
