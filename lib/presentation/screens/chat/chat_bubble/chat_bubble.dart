import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_bubble/widgets/chat_avatar.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_bubble/widgets/chat_bubble_content.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSentByMe;
  final bool showAvatar;
  final String? avatarUrl;
  final String? senderInitial;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    this.showAvatar = false,
    this.avatarUrl,
    this.senderInitial,
  });

  @override
  Widget build(BuildContext context) {
    final slideBegin = Offset(isSentByMe ? 0.3 : -0.3, 0);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, opacity, child) {
        return TweenAnimationBuilder<Offset>(
          tween: Tween(begin: slideBegin, end: Offset.zero),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) {
            return FractionalTranslation(
              translation: offset,
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        child: Row(
          mainAxisAlignment:
              isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSentByMe) ...[
              ChatAvatar(
                url: avatarUrl,
                initial: senderInitial ?? '?',
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: ChatBubbleContent(
                message: message,
                isSentByMe: isSentByMe,
              ),
            ),
            if (isSentByMe) const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}