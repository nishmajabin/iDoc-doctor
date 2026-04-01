import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_info_line.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_row_with_bar.dart';

class HelpAboutTeamCard extends StatelessWidget {
  const HelpAboutTeamCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gradientColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HelpAboutRowWithBar(label: 'App Info'),
          const SizedBox(height: 16),
          HelpAboutInfoLine(label: 'Developer', value: 'iDoc Technologies Pvt. Ltd.'),
          const SizedBox(height: 10),
          HelpAboutInfoLine(label: 'Build', value: '1.0.0+1'),
          const SizedBox(height: 10),
          HelpAboutInfoLine(label: 'Platform', value: 'Flutter • Firebase'),
          const SizedBox(height: 10),
          HelpAboutInfoLine(label: 'Contact', value: 'hello@idoc.health'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}