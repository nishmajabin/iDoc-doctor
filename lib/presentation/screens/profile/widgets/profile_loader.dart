import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class ProfileLoader extends StatelessWidget {
  const ProfileLoader({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
}
