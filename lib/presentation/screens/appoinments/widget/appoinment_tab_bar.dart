import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/tab_item.dart';

class AppointmentTabBar extends StatelessWidget {
  final bool isUpcomingSelected;

  const AppointmentTabBar({required this.isUpcomingSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 52,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          TabItem(
            label: 'Upcoming',
            isSelected: isUpcomingSelected,
            onTap: () => context
                .read<DoctorAppointmentBloc>()
                .add(const SwitchAppointmentTab(true)),
          ),
          TabItem(
            label: 'Past',
            isSelected: !isUpcomingSelected,
            onTap: () => context
                .read<DoctorAppointmentBloc>()
                .add(const SwitchAppointmentTab(false)),
          ),
        ],
      ),
    );
  }
}
