import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';
import 'package:intl/intl.dart';

class TotalRevenueBanner extends StatelessWidget {
  final DoctorProfileStats stats;
  final bool isLoading;
  const TotalRevenueBanner({required this.stats, required this.isLoading, super.key});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientStart.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.bgColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  Icon(Icons.account_balance_wallet_rounded,
                    color: AppColors.gradientColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text('Total Earnings',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.bgColor.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              if (isLoading)
                 SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                      color: AppColors.bgColor, strokeWidth: 2),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.bgColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.bgColor.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryLight),
                      ),
                      const SizedBox(width: 5),
                      Text('Live',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.bgColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            fmt.format(stats.totalRevenue),
            style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppColors.bgColor,
                letterSpacing: -1.5),
          ),
          const SizedBox(height: 6),
          Container(
              height: 1,
              color: AppColors.bgColor.withValues(alpha: 0.18),
              margin: const EdgeInsets.only(bottom: 10)),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded,
                  size: 16, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text('This month: ${fmt.format(stats.thisMonthRevenue)}',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.bgColor.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${stats.thisMonthAppointments} session${stats.thisMonthAppointments == 1 ? '' : 's'}',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.bgColor.withValues(alpha: 0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
