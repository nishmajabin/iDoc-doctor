import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/about_app_logo_section.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/about_info_card.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_gradient_appbar.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_team_card.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: HelpAboutGradientAppbar(title: 'About App'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          children: [
            AboutAppLogoSection(),
            const SizedBox(height: 28),
            HelpAboutInfoCard(),
            const SizedBox(height: 28),
            HelpAboutTeamCard(),
          ],
        ),
      ),
    );
  }
}
