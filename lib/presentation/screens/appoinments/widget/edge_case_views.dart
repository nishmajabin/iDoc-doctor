import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Unauthenticated view
// ─────────────────────────────────────────────────────────────────────────────

class UnauthenticatedView extends StatelessWidget {
  const UnauthenticatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return _ErrorScaffold(
      icon: Icons.lock_outline_rounded,
      iconBgColor: const Color(0xFFE0F4FF),
      iconColor: const Color(0xFF0077B6),
      title: 'Authentication Required',
      subtitle: 'Please login to your account to view and manage appointments.',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Invalid doctor view
// ─────────────────────────────────────────────────────────────────────────────

class InvalidDoctorView extends StatelessWidget {
  const InvalidDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return _ErrorScaffold(
      icon: Icons.person_off_outlined,
      iconBgColor: const Color(0xFFFFEBEB),
      iconColor: const Color(0xFFD13D3D),
      title: 'Profile Not Found',
      subtitle:
          'Your doctor profile could not be found. Please contact support.',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared scaffold
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorScaffold extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _ErrorScaffold({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      body: Stack(
        children: [
          // Header
          Container(
            height: topPadding + 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF052C40), Color(0xFF0077B6), Color(0xFF00B4D8)],
                stops: [0.0, 0.55, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 20),
            child: const Text(
              'Appointments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.only(top: topPadding + 80),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 40, color: iconColor),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2332),
                        letterSpacing: -0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7A91),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}