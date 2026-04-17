import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart'; // ← add import
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointment_loading_view.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appointments_header.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/loading_view.dart';

class AppointmentsContent extends StatelessWidget {
  final DoctorModel currentDoctor; // ← added

  const AppointmentsContent({
    super.key,
    required this.currentDoctor, // ← added
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      body: BlocConsumer<DoctorAppointmentBloc, DoctorAppointmentState>(
        listener: (context, state) {
          if (state is DoctorAppointmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.message,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFD13D3D),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: topPadding + 80),
                child: _buildBody(state),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppointmentsHeader(topPadding: topPadding, state: state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(DoctorAppointmentState state) {
    if (state is DoctorAppointmentLoading) {
      return const LoadingView();
    }
    if (state is DoctorAppointmentLoaded) {
      return AppointmentLoadingView(
        state: state,
        currentDoctor: currentDoctor, // ← now works
      );
    }
    return const SizedBox.shrink();
  }
}