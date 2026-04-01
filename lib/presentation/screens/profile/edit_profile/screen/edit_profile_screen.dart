import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/edit_profile/edit_profile_event.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/widgets/edit_profile_view.dart';

class EditProfileScreen extends StatelessWidget {
  final DoctorModel currentDoctor;
  const EditProfileScreen({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          EditProfileBloc()..add(EditProfileStarted(currentDoctor)),
      child: const EditProfileView(),
    );
  }
}
