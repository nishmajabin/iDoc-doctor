import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class FieldTile extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final bool isFirst;
  final bool isLast;
  final String? Function(String?)? validator;

  const FieldTile({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.enabled = true,
    this.isFirst = false,
    this.isLast = false,
    this.validator,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 14 : 10, 16, isLast ? 14 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              validator: validator,
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
                hintStyle: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textMuted),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                errorStyle: GoogleFonts.poppins(
                    fontSize: 10, color: AppColors.cancelled),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
