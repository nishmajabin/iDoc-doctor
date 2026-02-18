import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_event.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_state.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_state.dart';
import 'package:idoc_doctor_side/core/utils/home_utils.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/patient_card_row.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/header_widgets.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/state_widgets.dart';

class HomeBody extends StatelessWidget {
  final DoctorModel currentDoctor;
  const HomeBody({super.key, required this.currentDoctor});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorAppointmentBloc, DoctorAppointmentState>(
      listenWhen:
          (_, curr) =>
              curr is AppointmentActionSuccess ||
              curr is DoctorAppointmentError,
      listener: (context, state) {
        if (state is AppointmentActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is DoctorAppointmentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DoctorAppointmentLoading;

        final todayQueue = <DoctorAppointmentModel>[];
        final upcoming = <DoctorAppointmentModel>[];

        if (state is DoctorAppointmentLoaded) {
          splitAppointments(state.upcoming, todayQueue, upcoming);
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            final authState = context.read<DoctorAuthBloc>().state;
            if (authState is DoctorAuthSuccess) {
              context.read<DoctorAppointmentBloc>().add(
                RefreshDoctorAppointments(authState.doctor.id!),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: "Today's Queue",
                  subtitle:
                      (!isLoading && todayQueue.isNotEmpty)
                          ? '${todayQueue.length} patient${todayQueue.length == 1 ? '' : 's'}'
                          : null,
                  onSeeAll:
                      (!isLoading && todayQueue.isNotEmpty)
                          ? () => navigateToAllPatients(
                            context,
                            todayQueue,
                            "Today's Patients",
                            currentDoctor,
                          )
                          : null,
                ),
                const SizedBox(height: 14),
                if (isLoading)
                  const ShimmerRow()
                else if (todayQueue.isEmpty)
                  const EmptySection(
                    icon: Icons.today_rounded,
                    message: 'No patients lined up today',
                    subMessage: 'Enjoy your free time!',
                  )
                else
                  PatientCardRow(appointments: todayQueue, currentDoctor: currentDoctor,),
                const SizedBox(height: 32),
                SectionHeader(
                  title: 'Upcoming',
                  subtitle:
                      (!isLoading && upcoming.isNotEmpty)
                          ? '${upcoming.length} scheduled'
                          : null,
                  onSeeAll:
                      (!isLoading && upcoming.isNotEmpty)
                          ? () => navigateToAllPatients(
                            context,
                            upcoming,
                            'All Appointments',
                            currentDoctor
                          )
                          : null,
                ),
                const SizedBox(height: 14),
                if (isLoading)
                  const ShimmerRow()
                else if (upcoming.isEmpty)
                  const EmptySection(
                    icon: Icons.event_available_rounded,
                    message: 'No upcoming appointments',
                    subMessage: 'Your schedule is clear ahead',
                  )
                else
                  PatientCardRow(appointments: upcoming, currentDoctor: currentDoctor,),
              ],
            ),
          ),
        );
      },
    );
  }
}