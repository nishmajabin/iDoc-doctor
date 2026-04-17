
import 'package:flutter/material.dart';

class TabSegment extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const TabSegment({
    required this.label,
    required this.count,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )]
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15,
                  color: isSelected ? Colors.white : const Color(0xFFADB8C9)),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFADB8C9),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 230),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.22)
                        : const Color(0xFFEEF2F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFFADB8C9),
                    ),
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