import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_item.dart';

class SettingsGroup extends StatelessWidget {
  final List<SettingsItem> items;
  const SettingsGroup({required this.items, super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              item,
              if (i < items.length - 1)
                const Divider(
                    height: 1,
                    indent: 70,
                    endIndent: 16,
                    color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}
