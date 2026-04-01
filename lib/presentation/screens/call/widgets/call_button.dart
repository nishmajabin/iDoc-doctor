import 'package:flutter/material.dart';

/// A circular action button with an animated background and a text label below.
/// When [onPressed] is null the button renders in a disabled visual style
/// without any tap response.
class CallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color iconColor;
  final VoidCallback? onPressed;
  final double size;

  const CallButton({
    required this.icon,
    required this.label,
    required this.background,
    required this.iconColor,
    this.onPressed,
    this.size = 52,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isEnabled ? background : Colors.white12,
              shape: BoxShape.circle,
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: background.withValues(alpha: .4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: size * 0.42),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isEnabled ? Colors.white70 : Colors.white38,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}