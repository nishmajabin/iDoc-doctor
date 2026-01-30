import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_event.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_state.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorApplicationBloc, DoctorApplicationState>(
      builder: (context, state) {
        File? profileImage;

        if (state is DoctorApplicationFormUpdated) {
          profileImage = state.profileImage;
        }

        return GestureDetector(
          onTap: () {
            context.read<DoctorApplicationBloc>().add(PickProfileImageEvent());
          },
          child: Container(
            width: 300,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(58, 72, 131, 160),
              border: Border.all(color: AppColors.primaryColor, width: 1.5),
              image:
                  profileImage != null
                      ? DecorationImage(
                        image: FileImage(profileImage),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                profileImage == null
                    ? Icon(
                      CupertinoIcons.person_fill,
                      size: 60,
                      color: AppColors.primaryColor,
                    )
                    : null,
          ),
        );
      },
    );
  }
}
