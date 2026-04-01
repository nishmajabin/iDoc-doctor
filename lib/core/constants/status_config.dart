import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class StatusConfig {
  final String label;
  final Color color;
  final Color surface;

  const StatusConfig(this.label, this.color, this.surface);

  factory StatusConfig.from(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const StatusConfig('Confirmed', AppColors.confirmed, AppColors.primarySurface);
      case 'pending':
        return const StatusConfig('Pending',AppColors.pending, AppColors.pendingSurface);
      case 'completed':
        return const StatusConfig('Completed', AppColors.completed, AppColors.completedSurface);
      case 'cancelled':
        return const StatusConfig('Cancelled', AppColors.cancelled, AppColors.cancelledSurface);
      default:
        return StatusConfig(
          status.isEmpty
              ? 'Unknown'
              : status[0].toUpperCase() + status.substring(1).toLowerCase(),
          AppColors.textMuted,
          AppColors.bgBase,
        );
    }
  }
}
