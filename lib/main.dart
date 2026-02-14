import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/data/services/appointment_service.dart';
import 'package:idoc_doctor_side/data/services/slot_service.dart';
import 'package:idoc_doctor_side/firebase_options.dart';
import 'package:idoc_doctor_side/logic/blocs/appointment/appointment_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/auth/auth_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/bottom_nav/bottom_nav_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_application/doctor_application_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/doctor_login_form/login_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/log_out/logout_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot/slot_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/slot_form/slot_form_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/splash/splash_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/splash/splash_event.dart';
import 'package:idoc_doctor_side/presentation/screens/splash/splash_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(IDocDoctor());
}

class IDocDoctor extends StatelessWidget {
  const IDocDoctor({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashBloc()..add(StartSplash())),
        BlocProvider(create: (context) => DoctorApplicationBloc()),
        BlocProvider(create: (context) => DoctorAuthBloc()),
        BlocProvider(create: (context) => DoctorLoginFormBloc()),
        BlocProvider(create: (context) => BottomNavBloc()),
        BlocProvider(create: (context) => LogoutBloc()),
        BlocProvider(create: (context) => SlotFormBloc()),
        BlocProvider(create: (context) => DoctorAppointmentBloc(DoctorAppointmentService(FirebaseFirestore.instance))),
        BlocProvider(create: (context) => SlotBloc(slotService: SlotService(FirebaseFirestore.instance), doctorId: FirebaseAuth.instance.currentUser!.uid)),
        
      ],
      child: MaterialApp(
        home: SplashScreen(),
        title: 'iDoc-doctor',
        theme: ThemeData(fontFamily: GoogleFonts.libreFranklin().fontFamily),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}