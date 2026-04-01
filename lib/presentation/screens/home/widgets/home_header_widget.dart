import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/utils/home_utils.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_state.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/chat_room_list_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/doctor_avatar.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/glass_icon_button.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/screen/search_patients_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/screen/profile_screen.dart';

class HomeHeaderWidget extends StatelessWidget {
  final Function(BuildContext) onConfirmLogout;
  final DoctorModel currentDoctor;
  const HomeHeaderWidget({
    required this.onConfirmLogout,
    required this.currentDoctor,
    super.key,
  });

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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.lightColor],
              begin: Alignment.topLeft,
              stops: [0.25, 1.4],
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DoctorProfileScreen(
                                  currentDoctor: currentDoctor,
                                ),
                          ),
                        ),
                    child: DoctorAvatar(imageUrl: imageUrl, name: doctorName),
                  ),
                  const Spacer(),
                  Text(
                    'iDoc',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.bgColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  GlassIconButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ChatRoomListScreen(
                                doctorId: currentDoctor.id!,
                                currentUserId: currentDoctor.id!,
                                doctorName: currentDoctor.name,
                                doctorProfileImageUrl:
                                    currentDoctor.profileImageUrl,
                              ),
                        ),
                      );
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
                  color: AppColors.gradientColor.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Dr. ${getFirstName(doctorName)} 👋',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bgColor,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => SearchPatientsScreen(
                              currentDoctor: currentDoctor,
                            ),
                      ),
                    ),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.gradientColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.gradientColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.bgColor,
                          size: 22,
                        ),
                      ),
                      Text(
                        'Search patients by name…',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.gradientColor.withValues(alpha: 0.65),
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
