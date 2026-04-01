import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_app_bar.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_body.dart';

class PrescriptionView extends StatelessWidget {
  final DoctorAppointmentModel appointment;
  const PrescriptionView({required this.appointment, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PrescriptionBloc, PrescriptionState>(
      listener: _onStateChanged,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: const PrescriptionAppBar(),
        body: BlocBuilder<PrescriptionBloc, PrescriptionState>(
          builder: (context, state) {
            if (state is! PrescriptionFormState) return const SizedBox.shrink();
            return PrescriptionBody(appointment: appointment, state: state);
          },
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, PrescriptionState state) {
    if (state is PrescriptionSubmitSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Prescription submitted successfully'),
          ]),
          backgroundColor: const Color(0xFF43A047),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.pop(context);
    }

    if (state is PrescriptionSubmitError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}