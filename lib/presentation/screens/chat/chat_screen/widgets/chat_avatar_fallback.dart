import 'package:flutter/material.dart';

class ChatAvatarFallback extends StatelessWidget {
  final String name;
  const ChatAvatarFallback({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
      ),
    );
  }
}