import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_content.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_error_view.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_loader.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
        builder: (context, state) {
          if (state is DoctorProfileInitial || state is DoctorProfileLoading) {
            return const ProfileLoader();
          }
          if (state is DoctorProfileError) {
            return ProfileErrorView(message: state.message);
          }
          if (state is DoctorProfileLoaded) {
            return ProfileContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}