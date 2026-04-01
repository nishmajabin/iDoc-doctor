import 'package:flutter/material.dart';

class PrescriptionSubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final bool isEnabled;
  final VoidCallback? onTap;

  const PrescriptionSubmitButton({
    required this.isSubmitting,
    required this.isEnabled,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSubmitting || !isEnabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          color: !isEnabled ? const Color(0xFFBDBDBD) : const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
          boxShadow: !isEnabled
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Submit Prescription',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
      ),
    );
  }
}