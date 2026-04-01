import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class AvatarInitial extends StatelessWidget {
  final String initial;
  const AvatarInitial({required this.initial, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial.toUpperCase(),
        style: const TextStyle(
          color: AppColors.cardBg,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }
}