import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_event.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_view.dart';


class DoctorSettingsScreen extends StatelessWidget {
  final DoctorModel currentDoctor;
  const DoctorSettingsScreen({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(const LoadSettings()),
      child: SettingsView(doctor: currentDoctor),
    );
  }
}
