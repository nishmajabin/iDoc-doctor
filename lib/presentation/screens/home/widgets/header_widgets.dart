import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/utils/home_utils.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/home_header_widget.dart';

class HomeHeaderSection extends StatelessWidget {
  final DoctorModel currentDoctor;
  const HomeHeaderSection({super.key, required this.currentDoctor});

  @override
  Widget build(BuildContext context) {
    return HomeHeaderWidget(
      onConfirmLogout: _confirmLogout,
      currentDoctor: currentDoctor,
    );
  }

  void _confirmLogout(BuildContext context) {
    showLogoutDialog(context);
  }
}
