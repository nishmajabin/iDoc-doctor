import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_state.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/widgets/notification_setting_body.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return NotificationSettingBody(state: state);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.gradientColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Notification Settings',
        style: GoogleFonts.poppins(
          color: AppColors.gradientColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

