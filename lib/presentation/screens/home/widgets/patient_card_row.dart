import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/presentation/screens/patients/patient_detail_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/home/widgets/patient_card.dart';


class PatientCardRow extends StatelessWidget {
  final List<DoctorAppointmentModel> appointments;
  const PatientCardRow({required this.appointments, super.key});

  @override
  Widget build(BuildContext context) {
    final display = appointments.take(6).toList();
    return SizedBox(
      height: 182,
      child: ListView.builder(
        
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: display.length,
        itemBuilder:
            (_, i) => Padding(
              padding: EdgeInsets.only(right: i < display.length - 1 ? 12 : 0),
              child: SizedBox(
                width: 154,
                child: PatientCard(appointment: display[i], onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> PatientDetailScreen(appointment: display[i]))),),
              )
            ),
      ),
    );
  }
}

