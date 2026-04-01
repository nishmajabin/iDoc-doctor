import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class ChatSendButton extends StatelessWidget {
  final bool hasText;
  final bool isSending;
  final VoidCallback? onTap;

  const ChatSendButton({
    required this.hasText,
    required this.isSending,
    required this.onTap,
    super.key,
  });

  static const _activeGradient = LinearGradient(
    colors: [AppColors.chatSendColor, AppColors.avatarGradient],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _inactiveGradient = LinearGradient(
    colors: [AppColors.inactiveGradientColor, AppColors.inactiveGradientColor],
  );

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: hasText ? 1.0 : 0.8),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: hasText ? _activeGradient : _inactiveGradient,
          boxShadow: hasText
              ? [
                  BoxShadow(
                    color: AppColors.chatSendColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: AppColors.transparentColor,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Center(
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.cardBg,
                      ),
                    )
                  : Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: hasText ? AppColors.cardBg : AppColors.iconNoTextColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}