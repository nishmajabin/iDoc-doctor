import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/error_scaffold.dart';

class InvalidDoctorView extends StatelessWidget {
  const InvalidDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorScaffold(
      icon: Icons.person_off_outlined,
      iconBgColor: const Color(0xFFFFEBEB),
      iconColor: const Color(0xFFD13D3D),
      title: 'Profile Not Found',
      subtitle:
          'Your doctor profile could not be found. Please contact support.',
    );
  }
}
