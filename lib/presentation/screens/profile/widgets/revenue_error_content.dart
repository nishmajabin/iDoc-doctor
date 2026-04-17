import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RevenueErrorContent extends StatelessWidget {
  final String? message;
  const RevenueErrorContent({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Colors.red, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message ?? 'Something went wrong. Please try again.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.red.shade700,
            ),
          ),
        ),
      ],
    );
  }
}