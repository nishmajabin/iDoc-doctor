import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_list_view.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/segmented_tab_bar.dart';

class AppointmentLoadingView extends StatelessWidget {
  final DoctorAppointmentLoaded state;
  final DoctorModel currentDoctor; // ← added

  const AppointmentLoadingView({
    required this.state,
    required this.currentDoctor, // ← added
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedTabBar(
          isUpcomingSelected: state.isUpcomingSelected,
          upcomingCount: state.upcoming.length,
          pastCount: state.past.length,
        ),
        const SizedBox(height: 4),
        Expanded(
          child: AppointmentListView(
            appointments: state.isUpcomingSelected ? state.upcoming : state.past,
            isUpcoming: state.isUpcomingSelected,
            currentDoctor: currentDoctor, // ← added
          ),
        ),
      ],
    );
  }
}