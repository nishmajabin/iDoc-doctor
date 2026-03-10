import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/prescription_model.dart';
import 'package:idoc_doctor_side/data/services/prescription_service.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_event.dart';
import 'package:idoc_doctor_side/logic/blocs/prescription/prescription_state.dart';

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
      child: _ViewBody(patientName: patientName),
    );
  }
}

class _ViewBody extends StatelessWidget {
  final String patientName;
  const _ViewBody({required this.patientName});

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
              return _EmptyPrescription(patientName: patientName);
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.records.length,
              itemBuilder: (context, i) =>
                  _PrescriptionRecordCard(record: state.records[i]),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _PrescriptionRecordCard extends StatelessWidget {
  final PrescriptionRecord record;
  const _PrescriptionRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D0D0D),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.medical_services_rounded,
                    color: Color(0xFF00D4FF), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    record.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _formatDate(record.timestamp),
                  style: const TextStyle(
                      color: Color(0xFF9E9E9E), fontSize: 12),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Medications
                ...record.medications.asMap().entries.map(
                      (e) => _MedicationTile(
                          med: e.value, index: e.key + 1),
                    ),

                // Doctor's note
                if (record.docNote.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Doctor's Note",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9E9E9E),
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          record.docNote,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF424242),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

class _MedicationTile extends StatelessWidget {
  final PrescriptionMedication med;
  final int index;
  const _MedicationTile({required this.med, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text('$index',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0099CC),
                  )),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.medication,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D0D0D))),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _InfoChip('${med.dosage} Tablet'),
                    _InfoChip('${med.duration} ${med.durationUnit}'),
                    _InfoChip(med.repeat),
                    _InfoChip(med.timeOfDay),
                    _InfoChip(med.beTaken),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 11,
            color: Colors.white,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _EmptyPrescription extends StatelessWidget {
  final String patientName;
  const _EmptyPrescription({required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 44, color: Color(0xFFBDBDBD)),
          ),
          const SizedBox(height: 20),
          const Text('No Prescriptions Yet',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D0D0D))),
          const SizedBox(height: 8),
          Text('No prescriptions found for $patientName',
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF9E9E9E))),
        ],
      ),
    );
  }
}