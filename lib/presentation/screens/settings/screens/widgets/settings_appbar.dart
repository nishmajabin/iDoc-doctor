import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_circle.dart';

class SettingsAppBar extends StatelessWidget {
  final DoctorModel doctor;
  const SettingsAppBar({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.gradientColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative circles
            Positioned(
                top: -30, right: -30,
                child: SettingsCircle(size: 160, opacity: 0.08)),
            Positioned(
                bottom: 10, left: -20,
                child: SettingsCircle(size: 100, opacity: 0.06)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings',
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gradientColor,
                            letterSpacing: -0.5)),
                    Text('Manage your account & preferences',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.gradientColor.withValues(alpha: 0.7))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
