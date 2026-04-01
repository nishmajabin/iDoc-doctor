import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class DoctorAvatar extends StatelessWidget {
  final String? avatarUrl;

  const DoctorAvatar({this.avatarUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.gradientColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: avatarUrl != null && avatarUrl!.isNotEmpty
            ? Image.network(avatarUrl!, fit: BoxFit.cover)
            : Container(
                color: AppColors.gradientColor.withValues(alpha: 0.15),
                child:  Icon(
                  Icons.person,
                  color: AppColors.gradientColor,
                  size: 22,
                ),
              ),
      ),
    );
  }
}