import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_custom_circle.dart';

class EditProfileAppBar extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onSave;
  const EditProfileAppBar({required this.isSaving, required this.onSave, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon:  Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.bgColor, size: 20),
        onPressed: isSaving ? null : () => Navigator.pop(context),
      ),
      actions: [
        if (isSaving)
           Padding(
            padding: EdgeInsets.all(14),
            child: SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                  color: AppColors.gradientColor, strokeWidth: 2),
            ),
          )
        else
          TextButton(
            onPressed: onSave,
            child: Text('Save',
                style: GoogleFonts.poppins(
                    color: AppColors.bgColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ),
        const SizedBox(width: 8),
      ],
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
            Positioned(
                top: -30, right: -30,
                child: EditCustomCircle(size: 150, opacity: 0.08)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edit Profile',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.bgColor,
                            letterSpacing: -0.4)),
                    Text('Update your professional details',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.bgColor.withValues(alpha: 0.7))),
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