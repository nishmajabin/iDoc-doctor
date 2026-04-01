import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';

class SearchPatientHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged; // ← add this

  const SearchPatientHeader({
    required this.controller,
    required this.focusNode,
    this.onChanged, // ← add this
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topPad + 12, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.lightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.gradientColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.gradientColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child:  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.gradientColor,
                    size: 17,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                'Search Patients',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bgColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              return Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.gradientColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowDark.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onChanged, // ← wire it here
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by patient name…',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 14, right: 8),
                      child: Icon(
                        Icons.search_rounded,
                        color:
                            value.text.isNotEmpty
                                ? AppColors.primary
                                : AppColors.textMuted,
                        size: 22,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    suffixIcon:
                        value.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.cancel_rounded,
                                color: AppColors.textMuted,
                                size: 20,
                              ),
                              onPressed: () {
                                controller.clear();
                                onChanged?.call(''); // ← notify cubit on clear
                              },
                              splashRadius: 18,
                            )
                            : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 15,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
