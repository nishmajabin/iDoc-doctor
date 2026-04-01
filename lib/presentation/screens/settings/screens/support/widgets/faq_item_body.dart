import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/cubits/faq_item/faq_item_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/faq.dart';

class FaqItemBody extends StatelessWidget {
  final Faq faq;
  const FaqItemBody({required this.faq, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqItemCubit, bool>(
      builder: (context, isExpanded) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: AppColors.gradientColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isExpanded
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : AppColors.divider,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary
                      .withValues(alpha: isExpanded ? 0.07 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => context.read<FaqItemCubit>().toggle(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq.question,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedRotation(
                            turns: isExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.primary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 10),
                        const Divider(height: 1, color: AppColors.divider),
                        const SizedBox(height: 10),
                        Text(
                          faq.answer,
                          style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                              height: 1.7),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}