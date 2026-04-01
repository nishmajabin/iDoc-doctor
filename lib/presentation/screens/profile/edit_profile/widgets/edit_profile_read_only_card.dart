import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_read_only_row.dart';

class EditProfileReadOnlyCard extends StatelessWidget {
  final DoctorModel doctor;
  const EditProfileReadOnlyCard({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gradientColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          EditProfileReadOnlyRow(
            icon: Icons.email_outlined,
            iconColor: AppColors.primary,
            bgColor: AppColors.primarySurface,
            label: 'Email',
            value: doctor.email,
          ),
          const Divider(height: 20, indent: 52, color: AppColors.divider),
          EditProfileReadOnlyRow(
            icon: Icons.badge_outlined,
            iconColor: AppColors.completed,
            bgColor: AppColors.completedSurface,
            label: 'License Number',
            value: doctor.licenseNumber,
          ),
        ],
      ),
    );
  }
}
