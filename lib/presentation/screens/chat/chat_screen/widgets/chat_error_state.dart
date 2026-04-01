import 'package:flutter/material.dart';

class ChatErrorState extends StatelessWidget {
  final String message;
  const ChatErrorState({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: Color(0xFFE05C5C)),
            const SizedBox(height: 16),
            const Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF1A2332).withOpacity(0.5),
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}