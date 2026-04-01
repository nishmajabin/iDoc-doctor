import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_event.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorApplicationBloc, DoctorApplicationState>(
      builder: (context, state) {
        String? selectedGender;

        if (state is DoctorApplicationFormUpdated) {
          selectedGender = state.gender;
        }

        return Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                'Male',
                selectedGender == 'Male',
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              child: _buildGenderOption(
                context,
                'Female',
                selectedGender == 'Female',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    String gender,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        context.read<DoctorApplicationBloc>().add(UpdateGenderEvent(gender));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 3,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 30),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    isSelected
                        ? Border.all(color: Colors.black, width: 5)
                        : Border.all(color: Colors.grey, width: 2),
                color: isSelected ? Color(0xFF6AD2FF) : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              gender,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
