import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class EditCustomCircle extends StatelessWidget {
  final double size;
  final double opacity;
  const EditCustomCircle({required this.size, required this.opacity, super.key});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gradientColor.withValues(alpha: opacity),
        ),
      );
}