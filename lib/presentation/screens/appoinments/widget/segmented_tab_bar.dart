import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/tab_segment.dart';

class SegmentedTabBar extends StatelessWidget {
  final bool isUpcomingSelected;
  final int upcomingCount;
  final int pastCount;

  const SegmentedTabBar({
    required this.isUpcomingSelected,
    required this.upcomingCount,
    required this.pastCount,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF052C40).withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            TabSegment(
              label: 'Upcoming',
              count: upcomingCount,
              icon: Icons.upcoming_rounded,
              isSelected: isUpcomingSelected,
              onTap: () => context
                  .read<DoctorAppointmentBloc>()
                  .add(const SwitchAppointmentTab(true)),
            ),
            TabSegment(
              label: 'Past',
              count: pastCount,
              icon: Icons.history_rounded,
              isSelected: !isUpcomingSelected,
              onTap: () => context
                  .read<DoctorAppointmentBloc>()
                  .add(const SwitchAppointmentTab(false)),
            ),
          ],
        ),
      ),
    );
  }
}
