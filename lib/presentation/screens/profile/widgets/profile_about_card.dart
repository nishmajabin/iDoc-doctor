import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/settings/about/about_card_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/widgets/profile_about_card_body.dart';

class ProfileAboutCard extends StatelessWidget {
  final String bio;
  const ProfileAboutCard({required this.bio, super.key});

  // static const int preview = 160;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AboutCardCubit(),
      child: ProfileAboutCardBody(bio: bio),
    );
  }
}
