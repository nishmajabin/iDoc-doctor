import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class FieldDivider extends StatelessWidget {
  const FieldDivider({super.key});
  @override
  Widget build(BuildContext context) => const Divider(
    height: 1,
    indent: 70,
    endIndent: 16,
    color: AppColors.divider,
  );
}
