import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/data/repositories/chat_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/chat_room_list.dart/chat_room_list_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat_room_list.dart/chat_room_list_event.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/chat_room_list_view.dart';

class ChatRoomListScreen extends StatelessWidget {
  final String doctorId;
  final String currentUserId;
  final String? doctorName;
  final String? doctorProfileImageUrl;

  const ChatRoomListScreen({
    super.key,
    required this.doctorId,
    required this.currentUserId,
    this.doctorName,
    this.doctorProfileImageUrl,
  });

  static Route<void> route({
    required String doctorId,
    required String currentUserId,
    String? doctorName,
    String? doctorProfileImageUrl,
  }) {
    return MaterialPageRoute(
      builder: (_) => ChatRoomListScreen(
        doctorId: doctorId,
        currentUserId: currentUserId,
        doctorName: doctorName,
        doctorProfileImageUrl: doctorProfileImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatRoomListBloc(repository: ChatRepository())
        ..add(WatchDoctorChatRooms(doctorId)),
      child: ChatRoomListView(
        doctorId: doctorId,
        currentUserId: currentUserId,
        doctorName: doctorName,
        doctorProfileImageUrl: doctorProfileImageUrl,
      ),
    );
  }
}
