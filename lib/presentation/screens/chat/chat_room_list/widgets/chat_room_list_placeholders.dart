import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';

class EmptyInboxView extends StatelessWidget {
  const EmptyInboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ChatColors.primary.withValues(alpha: 0.08),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 44,
                color: ChatColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Messages Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ChatColors.textPrimary,
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Patient conversations will appear\nhere after appointments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ChatColors.textPrimary.withValues(alpha: 0.5),
                height: 1.5,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
