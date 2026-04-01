import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/search_patient_helpers.dart';

class SearchPatientAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isPast;

  const SearchPatientAvatar({
    required this.name,
    required this.imageUrl,
    required this.isPast,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final bgColor = isPast
        ? const Color(0xFFCDD5DF)
        : AppColors.primaryLight.withValues(alpha: 0.4);
    final fgColor = isPast ? AppColors.textSecondary : AppColors.primary;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        image: hasImage
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color:
                (isPast ? AppColors.shadowDark : AppColors.primary).withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: hasImage
          ? null
          : Center(
              child: Text(
                initials(name),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: fgColor,
                ),
              ),
            ),
    );
  }
}
