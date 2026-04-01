import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/core/data/services/prescription_service.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/screen/prescription_view.dart';

class PrescriptionScreen extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  const PrescriptionScreen({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrescriptionBloc(
        PrescriptionService(FirebaseFirestore.instance),
      ),
      child: PrescriptionView(appointment: appointment),
    );
  }
}