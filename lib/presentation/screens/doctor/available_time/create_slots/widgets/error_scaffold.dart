import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/slots_view/slots_view_screen.dart';

class ErrorScaffold extends StatelessWidget {
  final String title;
  final IconData icon;
  final String message;
  final Color? iconColor;
  final bool showNotesButton;

  const ErrorScaffold({
    super.key,
    required this.title,
    required this.icon,
    required this.message,
    this.iconColor,
    this.showNotesButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      body: Stack(
        children: [
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: topPadding + 72,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF052C40),
                    Color(0xFF0077B6),
                    Color(0xFF00B4D8),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Colors.grey).withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 48, color: iconColor ?? Colors.grey),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7A91),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (showNotesButton) ...[
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViewSlotsPage(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_view_month_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'View Slots',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}