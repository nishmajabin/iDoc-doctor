
import 'package:flutter/material.dart';

class MessageButton extends StatelessWidget {
  const MessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.chat_bubble_outline_rounded,
        color: Color(0xFF00D4FF),
        size: 18,
      ),
    );
  }
}
