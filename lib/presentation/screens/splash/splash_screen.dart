import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/splash/splash_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/splash/splash_state.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor_selection/screen/doctor_selection_screen.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompleted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> DoctorSelection()));
          }
        },
        builder: (context, state) {
          double scale = 1.0;
          if (state is SplashAnimating) {
            scale = state.scale;
          }
          return Center(
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.asset(
                  'assets/images/idoc_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}