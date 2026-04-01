import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/cubits/settings/about/about_card_cubit.dart';

class ProfileAboutCardBody extends StatelessWidget {
  final String bio;
  const ProfileAboutCardBody({required this.bio, super.key});

  static const int _preview = 160;

  @override
  Widget build(BuildContext context) {
    final isLong = bio.length > _preview;

    return BlocBuilder<AboutCardCubit, bool>(
      builder: (context, isExpanded) {
        final text = isExpanded || !isLong
            ? bio
            : '${bio.substring(0, _preview)}...';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.7,
                ),
              ),
              if (isLong) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => context.read<AboutCardCubit>().toggle(),
                  child: Text(
                    isExpanded ? 'Show less' : 'Read more',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}