import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class NotificationSettingCard extends StatelessWidget {
  final List<Widget> children;
  const NotificationSettingCard({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gradientColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}