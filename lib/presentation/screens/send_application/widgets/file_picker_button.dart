import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_event.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';

class FilePickerButton extends StatelessWidget {
  const FilePickerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorApplicationBloc, DoctorApplicationState>(
      builder: (context, state) {
        String? fileName;
        bool hasFile = false;

        if (state is DoctorApplicationFormUpdated) {
          fileName = state.licenseFileName;
          hasFile = state.licenseFile != null;
        }

        return GestureDetector(
          onTap: () {
            context.read<DoctorApplicationBloc>().add(PickLicenseFileEvent());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(30),
              border:
                  hasFile ? Border.all(color: Colors.green, width: 2) : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  hasFile ? Icons.check_circle : Icons.image_outlined,
                  color: hasFile ? Colors.green : AppColors.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    fileName ?? 'Pick From File',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: hasFile ? AppColors.primaryColor : Colors.black54,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (hasFile) const SizedBox(width: 8),
                if (hasFile)
                  Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
