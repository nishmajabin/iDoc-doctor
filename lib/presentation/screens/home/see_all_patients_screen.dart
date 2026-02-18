import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/patient_detail_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/patient_card.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/header_widgets.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/state_widgets.dart';

class SeeAllPatientsScreen extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;
  final String title;
  final DoctorModel currentDoctor; // ← added

  const SeeAllPatientsScreen({
    super.key,
    required this.appointments,
    required this.title,
    required this.currentDoctor, // ← added
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.bgBase,
        body: Column(
          children: [
            AllPatientsHeader(title: title),
            Expanded(
              child: appointments.isEmpty
                  ? const Center(
                      child: EmptySection(
                        icon: Icons.event_busy_rounded,
                        message: 'No appointments found',
                        subMessage: 'Nothing to show here',
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: appointments.length,
                      itemBuilder: (_, i) => PatientCard(
                        appointment: appointments[i],
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PatientDetailScreen(
                              appointment: appointments[i],
                              currentDoctor: currentDoctor, // ← passed down
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}