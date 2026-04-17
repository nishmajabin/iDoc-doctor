import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_profile_stats_model.dart';
import 'package:idoc_doctor_side/core/data/repositories/profile_repository.dart';
import 'package:idoc_doctor_side/logic/cubits/revenue/revenue_filter_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/break_down_card.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_stat_card.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/revenue_date_range_selector.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/revenue_filter_section_header.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/total_revenue_banner.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/filtered_revenue_card.dart';

class RevenueDashboard extends StatelessWidget {
  final DoctorProfileStats stats;
  final bool isLoading;
  final String doctorId;

  const RevenueDashboard({
    required this.stats,
    required this.isLoading,
    required this.doctorId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RevenueFilterCubit(
        repository: DoctorProfileRepository(), 
        doctorId: doctorId,
      ), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TotalRevenueBanner(stats: stats, isLoading: isLoading),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppColors.confirmed,
                  bgColor: AppColors.confirmedSurface,
                  label: 'Consultations',
                  value: stats.totalPaidAppointments.toString(),
                  sub: '${stats.thisMonthAppointments} this month',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.people_outline_rounded,
                  iconColor: AppColors.primary,
                  bgColor: AppColors.primarySurface,
                  label: 'Patients',
                  value: stats.totalPatients.toString(),
                  sub: 'Unique',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProfileStatCard(
                  icon: Icons.pending_actions_outlined,
                  iconColor: AppColors.pending,
                  bgColor: AppColors.pendingSurface,
                  label: 'Pending',
                  value: stats.pendingAppointments.toString(),
                  sub: 'Awaiting',
                ),
              ),
            ],
          ),
          if (!isLoading && stats.totalPaidAppointments > 0) ...[
            const SizedBox(height: 12),
            BreakdownCard(stats: stats),
          ],
          const SizedBox(height: 20),
          RevenueFilterSectionHeader(),
          const SizedBox(height: 10),
          const RevenueDateRangeSelector(),
          const SizedBox(height: 10),
          const FilteredRevenueCard(),
        ],
      ),
    );
  }
}
