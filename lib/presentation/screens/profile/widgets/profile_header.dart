import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/custom_circle.dart';

class ProfileHeader extends StatelessWidget {
  final DoctorModel doctor;
  const ProfileHeader({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
            top: -40, right: -40, child: CustomCircle(size: 200, opacity: 0.10)),
        Positioned(
            bottom: 20, left: -30, child: CustomCircle(size: 140, opacity: 0.07)),
        Positioned(
          bottom: 24, left: 0, right: 0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.gradientColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.shadowDark.withValues(alpha: 0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.accent.withValues(alpha: 0.3),
                  backgroundImage: doctor.profileImageUrl != null
                      ? NetworkImage(doctor.profileImageUrl!)
                      : null,
                  child: doctor.profileImageUrl == null
                      ? Text(_initials(doctor.name),
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.bgColor))
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text('Dr. ${doctor.name}',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bgColor,
                      letterSpacing: -0.3)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gradientColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.gradientColor.withValues(alpha: 0.3), width: 1),
                ),
                child: Text(doctor.specialist,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.bgColor.withValues(alpha: 0.95),
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
