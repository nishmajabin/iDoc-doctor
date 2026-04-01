import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Messages', style: ChatTextStyles.appBarTitle),
        Text('Patient consultations', style: ChatTextStyles.appBarSubtitle),
      ],
    );
  }
}