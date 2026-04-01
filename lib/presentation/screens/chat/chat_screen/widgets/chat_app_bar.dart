import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:idoc_doctor_side/core/constants/app_const.dart';
import 'package:idoc_doctor_side/core/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/presentation/screens/call/screen/video_call_screen.dart';
import 'chat_avatar_fallback.dart';

class ChatAppBar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isDoctor;
  final String appointmentId;
  final String patientName;
  final String doctorId;
  final String patientUserId;
  final String doctorName;
  final String? doctorProfileImageUrl;

  const ChatAppBar({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.isDoctor,
    required this.appointmentId,
    required this.patientName,
    required this.doctorId,
    required this.patientUserId,
    required this.doctorName,
    this.doctorProfileImageUrl,
  });

  Future<void> _startVideoCall(BuildContext context) async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    final granted = statuses.values.every((s) => s.isGranted);

    if (!context.mounted) return;

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and microphone permissions are required.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CallBloc(
            repository: CallRepository(),
            channelName: appointmentId,
            doctorId: doctorId,
            patientUserId: patientUserId,
            doctorName: doctorName,
            patientName: patientName,
            doctorProfileImageUrl: doctorProfileImageUrl,
          )..add(CallJoinRequested(
              channelName: appointmentId,
              appId: AppConstants.agoraAppId,
            )),
          child: VideoCallScreen(
            channelName: appointmentId,
            patientName: patientName,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
          top: topPadding + 8, bottom: 12, left: 4, right: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A6B6A), Color(0xFF0E7C7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E7C7B).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              color: Colors.white.withOpacity(0.15),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          ChatAvatarFallback(name: name),
                    )
                  : ChatAvatarFallback(name: name),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7FFFDD),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isDoctor ? 'Doctor' : 'Patient',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _startVideoCall(context),
              icon: const Icon(Icons.videocam_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}