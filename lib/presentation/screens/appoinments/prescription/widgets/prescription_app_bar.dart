import 'package:flutter/material.dart';

class PrescriptionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PrescriptionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF0D0D0D)),
      title: const Text(
        'New Prescription',
        style: TextStyle(
          color: Color(0xFF0D0D0D),
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFEEEEEE)),
      ),
    );
  }
}