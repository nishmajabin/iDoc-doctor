import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/cubits/patient/search_patient/search_patient_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/search_patients/widgets/search_patient_body.dart';

class SearchPatientsScreen extends StatelessWidget {
  final DoctorModel currentDoctor;

  const SearchPatientsScreen({
    super.key,
    required this.currentDoctor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchPatientsCubit(),
      child: SearchPatientsBody(currentDoctor: currentDoctor),
    );
  }
}
