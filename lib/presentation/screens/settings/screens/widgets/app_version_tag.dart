import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class AppVersionTag extends StatelessWidget {
  const AppVersionTag({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'iDoc Doctor v1.0.0 · Made with ❤️ in India',
        style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textMuted),
      ),
    );
  }
}
