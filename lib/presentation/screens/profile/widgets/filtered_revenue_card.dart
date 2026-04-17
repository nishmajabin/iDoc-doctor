// lib/presentation/screens/profile/widgets/filtered_revenue_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/cubits/revenue/revenue_filter_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/revenue/revenue_filter_state.dart';
import 'package:intl/intl.dart';

class FilteredRevenueCard extends StatelessWidget {
  const FilteredRevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueFilterCubit, RevenueFilterState>(
      builder: (context, state) {
        // Only show card when a range has been selected
        if (!state.hasRange) return const SizedBox.shrink();

        final fmt = NumberFormat.currency(symbol: '₹', decimalDigits: 0);
        final isLoading = state.status == RevenueFilterStatus.loading;
        final isError = state.status == RevenueFilterStatus.error;

        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isError
                    ? Colors.red.withValues(alpha: 0.25)
                    : AppColors.primary.withValues(alpha: 0.18),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isError
                ? _ErrorContent(message: state.errorMessage)
                : _ResultContent(
                    state: state,
                    fmt: fmt,
                    isLoading: isLoading,
                  ),
          ),
        );
      },
    );
  }
}

class _ResultContent extends StatelessWidget {
  final RevenueFilterState state;
  final NumberFormat fmt;
  final bool isLoading;

  const _ResultContent({
    required this.state,
    required this.fmt,
    required this.isLoading,
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
            ? _ShimmerPlaceholder()
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

class _ErrorContent extends StatelessWidget {
  final String? message;
  const _ErrorContent({this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message ?? 'Something went wrong. Please try again.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.red.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}