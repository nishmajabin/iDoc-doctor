import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class StatusConfig {
  final String label;
  final Color color;
  final Color surfaceColor;

  const StatusConfig({
    required this.label,
    required this.color,
    required this.surfaceColor,
  });

  factory StatusConfig.from(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const StatusConfig(
          label: 'Confirmed',
          color: AppColors.confirmed,
          surfaceColor: AppColors.confirmedSurface,
        );
      case 'pending':
        return const StatusConfig(
          label: 'Pending',
          color: AppColors.pending,
          surfaceColor: AppColors.pendingSurface,
        );
      case 'completed':
        return const StatusConfig(
          label: 'Completed',
          color: AppColors.completed,
          surfaceColor: AppColors.completedSurface,
        );
      case 'cancelled':
        return const StatusConfig(
          label: 'Cancelled',
          color: AppColors.cancelled,
          surfaceColor: AppColors.cancelledSurface,
        );
      default:
        return StatusConfig(
          label: status[0].toUpperCase() + status.substring(1).toLowerCase(),
          color: AppColors.textSecondary,
          surfaceColor: AppColors.surface,
        );
    }
  }
}
