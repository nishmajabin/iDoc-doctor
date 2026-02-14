import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/bottom_nav/bottom_nav_event.dart';
import 'package:idoc_doctor_side/logic/blocs/bottom_nav/bottom_nav_state.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_state.dart';
import 'package:idoc_doctor_side/presentation/bottom_nav/bottom_nav.dart';
import 'package:idoc_doctor_side/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/create_slots_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/home/home_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/notification/notification_screen.dart';
import 'package:idoc_doctor_side/presentation/widgets/doctor_appointment_screen.dart';

class BottomScreen extends StatelessWidget {
  final DoctorModel doctor;
  const BottomScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          try {
            context.read<BottomNavBloc>().add(const BottomNavReset());
          } catch (e) {
            throw Exception('BottomNavBloc reset error: $e');
          }
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => DoctorLoginScreen()),
                (route) => false,
              );
            }
          });
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFE6EFF9),
            body: _buildBody(state.currentIndex),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<BottomNavBloc>().add(BottomNavTabChanged(index));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return const DoctorHomeScreen();
      case 1:
        return CreateSlotsPage();
      case 2:
        return const NotificationScreen();
      case 3:
        return DoctorAppointmentsScreen();
      default:
        return const DoctorHomeScreen();
    }
  }
}