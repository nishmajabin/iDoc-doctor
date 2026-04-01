import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_bubble/widgets/avatar_initial.dart';

class ChatAvatar extends StatelessWidget {
  final String? url;
  final String initial;

  const ChatAvatar({
    required this.initial,
    this.url,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient:  LinearGradient(
          colors: [AppColors.chatSendColor, AppColors.avatarGradient],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.chatSendColor.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: url != null && url!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => AvatarInitial(initial: initial),
              ),
            )
          : AvatarInitial(initial: initial),
    );
  }
}

