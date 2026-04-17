import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/cubits/revenue/revenue_filter_cubit.dart';
import 'package:idoc_doctor_side/logic/cubits/revenue/revenue_filter_state.dart';

class RevenueDateRangeSelector extends StatelessWidget {
  const RevenueDateRangeSelector({super.key});

  Future<void> _pickDateRange(
      BuildContext context, RevenueFilterState state) async {
    final now = DateTime.now();
    final initialRange = state.hasRange
        ? DateTimeRange(start: state.startDate!, end: state.endDate!)
        : DateTimeRange(
            start: now.subtract(const Duration(days: 29)),
            end: now,
          );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: initialRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.bgColor,
              surface: AppColors.cardBg,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && context.mounted) {
      context.read<RevenueFilterCubit>().applyDateRange(
            picked.start,
            picked.end,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevenueFilterCubit, RevenueFilterState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _pickDateRange(context, state),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: state.hasRange
                          ? AppColors.primary.withValues(alpha: 0.4)
                          : AppColors.divider,
                      width: state.hasRange ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 18,
                        color: state.hasRange
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          state.formattedRange,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: state.hasRange
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: state.hasRange
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (state.hasRange) ...[
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () =>
                              context.read<RevenueFilterCubit>().clearFilter(),
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}