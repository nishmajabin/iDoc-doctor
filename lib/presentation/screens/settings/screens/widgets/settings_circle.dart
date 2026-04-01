import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class SettingsCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const SettingsCircle({required this.size, required this.opacity, super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.bgColor.withValues(alpha: opacity),
        ),
      );
}