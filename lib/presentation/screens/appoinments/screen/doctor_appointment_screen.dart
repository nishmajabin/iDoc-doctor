import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/services/appointment_service.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/appoinment_content.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/edge_case_views.dart';

class DoctorAppointmentsScreen extends StatelessWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<DoctorAuthBloc>().state;

    if (authState is! DoctorAuthSuccess) {
      return const UnauthenticatedView();
    }

    final doctorId = authState.doctor.id;
    if (doctorId == null || doctorId.isEmpty) {
      return const InvalidDoctorView();
    }

    return BlocProvider(
      create:
          (context) => DoctorAppointmentBloc(
            DoctorAppointmentService(FirebaseFirestore.instance),
          )..add(FetchDoctorAppointments(doctorId)),
      child: const AppointmentsContent(),
    );
  }
}

