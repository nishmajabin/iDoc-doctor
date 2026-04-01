import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});
  @override
  Widget build(BuildContext context) => const Divider(
    height: 1,
    indent: 66,
    endIndent: 16,
    color: AppColors.divider,
  );
}
