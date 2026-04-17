import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_state.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/empty_prescription.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_record_card.dart';

class PrescriptionViewBody extends StatelessWidget {
  final String patientName;
  const PrescriptionViewBody({required this.patientName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0D0D0D)),
        title: const Text(
          'Prescription',
          style: TextStyle(
            color: Color(0xFF0D0D0D),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEEE)),
        ),
      ),
      body: BlocBuilder<PrescriptionBloc, PrescriptionState>(
        builder: (context, state) {
          if (state is PrescriptionViewLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
            );
          }

          if (state is PrescriptionViewError) {
            return Center(
              child: Text(state.message,
                  style: const TextStyle(color: Color(0xFFE53935))),
            );
          }

          if (state is PrescriptionViewLoaded) {
            if (state.records.isEmpty) {
              return EmptyPrescription(patientName: patientName);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.records.length,
              itemBuilder: (context, i) =>
                  PrescriptionRecordCard(record: state.records[i]),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
