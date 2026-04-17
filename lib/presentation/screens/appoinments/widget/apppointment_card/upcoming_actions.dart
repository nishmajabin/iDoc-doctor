import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/app_const.dart';
import 'package:idoc_doctor_side/core/data/models/appointment_model.dart';
import 'package:idoc_doctor_side/core/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/presentation/screens/call/screen/video_call_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class UpcomingActions extends StatelessWidget {
  final DoctorAppointmentModel appointment;

  const UpcomingActions({required this.appointment, super.key});

  Future<void> _startVideoCall(BuildContext context) async {
    // 1. Request camera + mic permissions
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final granted = statuses.values.every((s) => s.isGranted);

    // 2. Guard against widget unmount during async gap
    if (!context.mounted) return;

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and microphone permissions are required.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 3. Navigate to video call screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CallBloc(
            repository: CallRepository(),
            channelName: appointment.appointmentId,
            doctorId: appointment.doctorId,
            patientUserId: appointment.userId, // patient's Firebase Auth UID
            doctorName: appointment.doctorName ?? 'Doctor',
            patientName: appointment.patientName,
            doctorProfileImageUrl: appointment.doctorProfileImageUrl,
          )..add(
              CallJoinRequested(
                channelName: appointment.appointmentId,
                appId: AppConstants.agoraAppId,
              ),
            ),
          child: VideoCallScreen(
            channelName: appointment.appointmentId,
            patientName: appointment.patientName,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ── Primary CTA ──────────────────────────────────────────────────
        Expanded(
          flex: 3,
          child: GestureDetector(
            onTap: () => _startVideoCall(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF052C40), Color(0xFF0077B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0077B6).withOpacity(0.28),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.videocam_rounded, color: Colors.white, size: 15),
                  SizedBox(width: 7),
                  Text(
                    'Start Consultation',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),


      ],
    );
  }
}