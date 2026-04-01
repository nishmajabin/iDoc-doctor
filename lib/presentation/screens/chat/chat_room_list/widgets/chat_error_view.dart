import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';

class ChatErrorView extends StatelessWidget {
  final String message;

  const ChatErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(
          color: ChatColors.error,
          fontFamily: 'Nunito',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}