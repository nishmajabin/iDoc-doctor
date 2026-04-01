import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/status_config.dart';

class SearchPatientStatusBadge extends StatelessWidget {
  final StatusConfig config;

  const SearchPatientStatusBadge({required this.config, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.surface,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: config.color.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: config.color,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            config.label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }
}