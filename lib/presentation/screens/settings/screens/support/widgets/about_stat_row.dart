import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/about_stat.dart';

class AboutStatRow extends StatelessWidget {
  const AboutStatRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        HelpAboutStat(value: '10K+', label: 'Doctors'),
        HelpAboutStat(value: '500K+', label: 'Patients'),
        HelpAboutStat(value: '4.8 ★', label: 'Rating'),
      ],
    );
  }
}
