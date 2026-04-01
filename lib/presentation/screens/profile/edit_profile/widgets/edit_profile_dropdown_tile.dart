import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class EditProfileDropdownTile extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String? value;
  final List<String> items;
  final bool enabled;
  final bool isFirst;
  final bool isLast;
  final ValueChanged<String?> onChanged;

  const EditProfileDropdownTile({
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.isFirst = false,
    this.isLast = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 14 : 10, 16, isLast ? 14 : 10),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: value,
              hint: Text(hint,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textMuted)),
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary, size: 20),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e,
                            style: GoogleFonts.poppins(
                                fontSize: 13.5,
                                color: AppColors.textPrimary)),
                      ))
                  .toList(),
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}
