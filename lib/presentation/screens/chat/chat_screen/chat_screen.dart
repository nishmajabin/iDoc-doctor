import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/repositories/chat_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_event.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/widgets/chat_view.dart';

class ChatScreen extends StatelessWidget {
  final String doctorId;
  final String patientId;
  final String appointmentId;
  final String currentUserId;
  final bool currentUserIsDoctor;
  final String? doctorName;
  final String? patientName;
  final String? doctorProfileImageUrl;
  final String? patientProfileImageUrl;

  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
    required this.currentUserId,
    required this.currentUserIsDoctor,
    this.doctorName,
    this.patientName,
    this.doctorProfileImageUrl,
    this.patientProfileImageUrl,
  });

  static Route<void> route({
    required String doctorId,
    required String patientId,
    required String appointmentId,
    required String currentUserId,
    required bool currentUserIsDoctor,
    String? doctorName,
    String? patientName,
    String? doctorProfileImageUrl,
    String? patientProfileImageUrl,
  }) =>
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          doctorId: doctorId,
          patientId: patientId,
          appointmentId: appointmentId,
          currentUserId: currentUserId,
          currentUserIsDoctor: currentUserIsDoctor,
          doctorName: doctorName,
          patientName: patientName,
          doctorProfileImageUrl: doctorProfileImageUrl,
          patientProfileImageUrl: patientProfileImageUrl,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(repository: ChatRepository())
        ..add(InitializeChatRoom(
          doctorId: doctorId,
          patientId: patientId,
          appointmentId: appointmentId,
          currentUserId: currentUserId,
          currentUserIsDoctor: currentUserIsDoctor,
          doctorName: doctorName,
          patientName: patientName,
          doctorProfileImageUrl: doctorProfileImageUrl,
          patientProfileImageUrl: patientProfileImageUrl,
        )),
      child: ChatView(
        currentUserIsDoctor: currentUserIsDoctor,
        otherName: currentUserIsDoctor
            ? (patientName ?? 'Patient')
            : (doctorName ?? 'Doctor'),
        otherAvatarUrl:
            currentUserIsDoctor ? patientProfileImageUrl : doctorProfileImageUrl,
        appointmentId: appointmentId,
        patientName: patientName ?? 'Patient',
        doctorId: doctorId,
        patientUserId: patientId,
        doctorName: doctorName ?? 'Doctor',
        doctorProfileImageUrl: doctorProfileImageUrl,
      ),
    );
  }
}