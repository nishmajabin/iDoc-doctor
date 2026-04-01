import 'package:flutter/material.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0E7C7B).withOpacity(0.1),
                    const Color(0xFF27C4C3).withOpacity(0.08),
                  ],
                ),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: Color(0xFF0E7C7B),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start the Conversation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to begin your\nconsultation session.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF1A2332).withOpacity(0.5),
                fontFamily: 'Nunito',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

