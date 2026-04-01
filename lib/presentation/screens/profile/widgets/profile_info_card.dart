import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/custom_divider.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_info_row.dart';

class ProfileInfoCard extends StatelessWidget {
  final DoctorModel doctor;
  const ProfileInfoCard({required this.doctor, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ProfileInfoRow(
              icon: Icons.email_outlined,
              iconColor: AppColors.primary,
              bgColor: AppColors.primarySurface,
              label: 'Email',
              value: doctor.email,
              isFirst: true),
          CustomDivider(),
          ProfileInfoRow(
              icon: Icons.phone_outlined,
              iconColor: AppColors.confirmed,
              bgColor: AppColors.confirmedSurface,
              label: 'Phone',
              value: doctor.phone),
          CustomDivider(),
          ProfileInfoRow(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.pending,
              bgColor: AppColors.pendingSurface,
              label: 'Location',
              value: doctor.place),
          CustomDivider(),
          ProfileInfoRow(
              icon: Icons.badge_outlined,
              iconColor: AppColors.completed,
              bgColor: AppColors.completedSurface,
              label: 'License No.',
              value: doctor.licenseNumber),
          CustomDivider(),
          ProfileInfoRow(
              icon: Icons.workspace_premium_outlined,
              iconColor: AppColors.accent,
              bgColor: AppColors.primarySurface,
              label: 'Experience',
              value: '${doctor.experience} years'),
          CustomDivider(),
          ProfileInfoRow(
              icon: Icons.wc_outlined,
              iconColor: AppColors.textSecondary,
              bgColor: AppColors.bgColor,
              label: 'Gender',
              value: doctor.gender,
              isLast: true),
        ],
      ),
    );
  }
}