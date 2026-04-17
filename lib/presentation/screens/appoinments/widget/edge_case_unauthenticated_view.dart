import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/error_scaffold.dart';

class UnauthenticatedView extends StatelessWidget {
  const UnauthenticatedView({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorScaffold(
      icon: Icons.lock_outline_rounded,
      iconBgColor: const Color(0xFFE0F4FF),
      iconColor: const Color(0xFF0077B6),
      title: 'Authentication Required',
      subtitle: 'Please login to your account to view and manage appointments.',
    );
  }
}
