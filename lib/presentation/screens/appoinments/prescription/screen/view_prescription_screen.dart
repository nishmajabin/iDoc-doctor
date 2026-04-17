import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/services/prescription_service.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_view_body.dart';

class ViewPrescriptionScreen extends StatelessWidget {
  final String appointmentId;
  final String patientName;

  const ViewPrescriptionScreen({
    required this.appointmentId,
    required this.patientName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrescriptionBloc(
        PrescriptionService(FirebaseFirestore.instance),
      )..add(LoadPrescriptions(appointmentId)),
      child: PrescriptionViewBody(patientName: patientName),
    );
  }
}
