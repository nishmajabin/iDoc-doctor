import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/cubits/revenue/revenue_filter_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/revenue_shimmer_placeholder.dart';
import 'package:intl/intl.dart';

class RevenueResultContent extends StatelessWidget {
  final RevenueFilterState state;
  final NumberFormat fmt;
  final bool isLoading;

  const RevenueResultContent({
    required this.state,
    required this.fmt,
    required this.isLoading,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.filter_alt_rounded,
                  size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Filtered Earnings',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (isLoading)
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        isLoading
            ? RevenueShimmerPlaceholder()
            : Text(
                fmt.format(state.filteredRevenue),
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -1,
                ),
              ),
        const SizedBox(height: 4),
        Text(
          state.formattedRange,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        if (!isLoading && state.filteredAppointments > 0) ...[
          const SizedBox(height: 8),
          Container(
            height: 1,
            color: AppColors.divider,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded,
                  size: 14, color: AppColors.confirmed),
              const SizedBox(width: 6),
              Text(
                '${state.filteredAppointments} paid session${state.filteredAppointments == 1 ? '' : 's'} in this range',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
