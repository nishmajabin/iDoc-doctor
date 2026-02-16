
import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appoinment_tab_bar.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_list_view.dart';

class AppointmentLoadingView extends StatelessWidget {
  final DoctorAppointmentLoaded state;

  const AppointmentLoadingView({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        AppointmentTabBar(isUpcomingSelected: state.isUpcomingSelected),
        const SizedBox(height: 20),
        Expanded(
          child: AppointmentListView(
            appointments:
                state.isUpcomingSelected ? state.upcoming : state.past,
            isUpcoming: state.isUpcomingSelected,
          ),
        ),
      ],
    );
  }
}
