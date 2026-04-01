import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/providers/eager_fetch.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';

class AppointmentFetcher extends StatelessWidget {
  final Widget child;
   const AppointmentFetcher({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorAuthBloc, DoctorAuthState>(
      listenWhen:
          (prev, curr) =>
              curr is DoctorAuthSuccess && prev is! DoctorAuthSuccess,
      listener: (context, state) {
        if (state is DoctorAuthSuccess) {
          context.read<DoctorAppointmentBloc>().add(
            FetchDoctorAppointments(state.doctor.id!),
          );
        }
      },
      child: EagerFetch(child: child),
    );
  }
}
