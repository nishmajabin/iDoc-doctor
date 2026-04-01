import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';

class EagerFetch extends StatelessWidget {
  final Widget child;
  const EagerFetch({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<DoctorAuthBloc>().state;
    if (authState is DoctorAuthSuccess) {
      final apptState = context.read<DoctorAppointmentBloc>().state;
      if (apptState is! DoctorAppointmentLoaded &&
          apptState is! DoctorAppointmentLoading) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<DoctorAppointmentBloc>().add(
            FetchDoctorAppointments(authState.doctor.id!),
          );
        });
      }
    }
    return child;
  }
}