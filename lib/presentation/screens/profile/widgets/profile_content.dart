import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_event.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_about_card.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_header.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_info_card.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_section_label.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/revenue_dashboard.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/settings_screen.dart';

class ProfileContent extends StatelessWidget {
  final DoctorProfileLoaded state;
  const ProfileContent({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = state.doctor;
    final stats  = state.stats;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.gradientStart,
          elevation: 0,
          leading: IconButton(
            icon:  Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.gradientColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // ── Refresh stats ──────────────────────────────────────────────
            state.isStatsRefreshing
                ?  Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          color: AppColors.gradientColor, strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon:  Icon(Icons.refresh_rounded,
                        color: AppColors.gradientColor, size: 22),
                    onPressed: () => context
                        .read<DoctorProfileBloc>()
                        .add(RefreshProfileStats(doctorId: doctor.id!)),
                  ),
            // ── Settings ───────────────────────────────────────────────────
            IconButton(
              icon:  Icon(Icons.settings_outlined,
                  color: AppColors.gradientColor, size: 22),
              tooltip: 'Settings',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DoctorSettingsScreen(currentDoctor: doctor),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            background: ProfileHeader(doctor: doctor),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileSectionLabel(label: 'Revenue Overview'),
                const SizedBox(height: 12),
                RevenueDashboard(
                    stats: stats, isLoading: state.isStatsRefreshing),
                const SizedBox(height: 28),
                ProfileSectionLabel(label: 'About'),
                const SizedBox(height: 12),
                ProfileAboutCard(bio: doctor.bio),
                const SizedBox(height: 28),
                ProfileSectionLabel(label: 'Information'),
                const SizedBox(height: 12),
                ProfileInfoCard(doctor: doctor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
