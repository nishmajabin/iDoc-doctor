import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_state.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients_screen.dart';
import './avatar_widgets.dart';
import '../../../../core/utils/home_utils.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection();

  @override
  Widget build(BuildContext context) {
    return HomeHeaderWidget(onConfirmLogout: _confirmLogout);
  }

  void _confirmLogout(BuildContext context) {
    showLogoutDialog(context);
  }
}

class HomeHeaderWidget extends StatelessWidget {
  final Function(BuildContext) onConfirmLogout;
  const HomeHeaderWidget({required this.onConfirmLogout});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return BlocBuilder<DoctorAuthBloc, DoctorAuthState>(
      buildWhen: (prev, curr) {
        if (curr is DoctorAuthSuccess && prev is DoctorAuthSuccess) {
          return curr.doctor.name != prev.doctor.name ||
              curr.doctor.profileImageUrl != prev.doctor.profileImageUrl;
        }
        return curr.runtimeType != prev.runtimeType;
      },
      builder: (context, authState) {
        final doctorName =
            authState is DoctorAuthSuccess ? authState.doctor.name : 'Doctor';
        final imageUrl =
            authState is DoctorAuthSuccess
                ? authState.doctor.profileImageUrl
                : null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, topPad + 16, 20, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradientStart, AppColors.gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DoctorAvatar(imageUrl: imageUrl, name: doctorName),
                  const Spacer(),
                  Text(
                    'iDoc',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  GlassIconButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      // TODO: navigate to chat screen
                    },
                  ),
                  const SizedBox(width: 10),
                  BlocBuilder<LogoutBloc, LogoutState>(
                    buildWhen:
                        (prev, curr) =>
                            curr is LogoutLoading || prev is LogoutLoading,
                    builder: (context, logoutState) {
                      final isLoggingOut = logoutState is LogoutLoading;
                      return GlassIconButton(
                        icon: Icons.logout_rounded,
                        isLoading: isLoggingOut,
                        onTap:
                            isLoggingOut
                                ? null
                                : () => onConfirmLogout(context),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Good ${timeOfDayGreeting()},',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.75),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Dr. ${getFirstName(doctorName)} 👋',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchPatientsScreen(),
                      ),
                    ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      Text(
                        'Search patients by name…',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.65),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;

  const SectionHeader({required this.title, this.subtitle, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
        const Spacer(),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'See All',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AllPatientsHeader extends StatelessWidget {
  final String title;
  const AllPatientsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}
