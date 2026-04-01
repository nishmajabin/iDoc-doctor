import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/break_down_item.dart';

class BreakdownCard extends StatelessWidget {
  final DoctorProfileStats stats;
  const BreakdownCard({required this.stats, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: BreakdownItem(
                color: AppColors.completed,
                bgColor: AppColors.completedSurface,
                label: 'Completed',
                value: stats.totalCompletedAppointments,
                tooltip: 'Consultation done'),
          ),
          Container(width: 1, height: 36, color: AppColors.divider),
          Expanded(
            child: BreakdownItem(
                color: AppColors.confirmed,
                bgColor: AppColors.confirmedSurface,
                label: 'Confirmed',
                value: stats.totalConfirmedAppointments,
                tooltip: 'Paid, awaiting consultation'),
          ),
        ],
      ),
    );
  }
}