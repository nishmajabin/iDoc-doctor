import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/prescription_model.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/prescription/widgets/prescription_info_chip.dart';

class MedicationTile extends StatelessWidget {
  final PrescriptionMedication med;
  final int index;
  const MedicationTile({required this.med, required this.index, super.key});

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
                    PrescriptionInfoChip('${med.dosage} Tablet'),
                    PrescriptionInfoChip('${med.duration} ${med.durationUnit}'),
                    PrescriptionInfoChip(med.repeat),
                    PrescriptionInfoChip(med.timeOfDay),
                    PrescriptionInfoChip(med.beTaken),
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