import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/utils/home_utils.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/header_widgets.dart';

class HomeHeader extends StatelessWidget {
  final DoctorModel currentDoctor;
  const HomeHeader({super.key, required this.currentDoctor});

  @override
  Widget build(BuildContext context) {
    return HomeHeaderWidget(onConfirmLogout: _confirmLogout, currentDoctor: currentDoctor,);
  }

  void _confirmLogout(BuildContext context) {
    showLogoutDialog(context);
  }
}
