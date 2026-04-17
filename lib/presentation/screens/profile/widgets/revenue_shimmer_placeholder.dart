import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class RevenueShimmerPlaceholder extends StatelessWidget {
  const RevenueShimmerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
