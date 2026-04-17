import 'package:flutter/material.dart';

class EmptyPrescription extends StatelessWidget {
  final String patientName;
  const EmptyPrescription({required this.patientName, super.key});

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