import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_list_view.dart';

class AppointmentLoadingView extends StatelessWidget {
  final DoctorAppointmentLoaded state;

  const AppointmentLoadingView({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SegmentedTabBar(
          isUpcomingSelected: state.isUpcomingSelected,
          upcomingCount: state.upcoming.length,
          pastCount: state.past.length,
        ),
        const SizedBox(height: 4),
        Expanded(
          child: AppointmentListView(
            appointments: state.isUpcomingSelected ? state.upcoming : state.past,
            isUpcoming: state.isUpcomingSelected,
          ),
        ),
      ],
    );
  }
}

class _SegmentedTabBar extends StatelessWidget {
  final bool isUpcomingSelected;
  final int upcomingCount;
  final int pastCount;

  const _SegmentedTabBar({
    required this.isUpcomingSelected,
    required this.upcomingCount,
    required this.pastCount,
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
            _TabSegment(
              label: 'Upcoming',
              count: upcomingCount,
              icon: Icons.upcoming_rounded,
              isSelected: isUpcomingSelected,
              onTap: () => context
                  .read<DoctorAppointmentBloc>()
                  .add(const SwitchAppointmentTab(true)),
            ),
            _TabSegment(
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

class _TabSegment extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabSegment({
    required this.label,
    required this.count,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 230),
          curve: Curves.easeInOutCubic,
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )]
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15,
                  color: isSelected ? Colors.white : const Color(0xFFADB8C9)),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFADB8C9),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.1,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 230),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.22)
                        : const Color(0xFFEEF2F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFFADB8C9),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}