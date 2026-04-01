import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_event.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_view.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorModel currentDoctor;
  const DoctorProfileScreen({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorProfileBloc()
        ..add(LoadDoctorProfile(currentDoctor.id!)),
      child: const ProfileView(),
    );
  }
}

