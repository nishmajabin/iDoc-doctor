import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class HelpAboutGradientAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const HelpAboutGradientAppbar({required this.title, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.gradientColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title,
          style: GoogleFonts.poppins(
              color: AppColors.gradientColor, fontSize: 18, fontWeight: FontWeight.w600)),
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