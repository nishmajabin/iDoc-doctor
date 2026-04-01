import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class HelpDivider extends StatelessWidget {
  const HelpDivider({super.key});
  @override
  Widget build(BuildContext context) => const Divider(
      height: 1, indent: 70, endIndent: 16, color: AppColors.divider);
}