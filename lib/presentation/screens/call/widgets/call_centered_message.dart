import 'package:flutter/material.dart';

class CallCenteredMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showSpinner;
  final Color iconColor;

  const CallCenteredMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.showSpinner = false,
    this.iconColor = Colors.white70,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: const Color(0xCC0D0D0D),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: iconColor),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
              if (showSpinner) ...[
                const SizedBox(height: 24),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white38,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}