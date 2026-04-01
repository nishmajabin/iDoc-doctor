import 'package:flutter/material.dart';

class AddMedicationButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddMedicationButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF00D4FF).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
          ),
        ),
        alignment: Alignment.center,
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_circle_outline_rounded,
                color: Color(0xFF0099CC), size: 18),
            SizedBox(width: 8),
            Text(
              'Add Medication',
              style: TextStyle(
                color: Color(0xFF0099CC),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}