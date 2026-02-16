import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/utils/home_utils.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/header_widgets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeHeaderWidget(onConfirmLogout: _confirmLogout);
  }

  void _confirmLogout(BuildContext context) {
    showLogoutDialog(context);
  }
}