import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_room_list_appbar.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_room_list_body.dart';

class ChatRoomListView extends StatelessWidget {
  final String doctorId;
  final String currentUserId;
  final String? doctorName;
  final String? doctorProfileImageUrl;

  const ChatRoomListView({
    required this.doctorId,
    required this.currentUserId,
    this.doctorName,
    this.doctorProfileImageUrl,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FC),
        body: Column(
          children: [
            ChatRoomListAppBar(
              doctorName: doctorName,
              avatarUrl: doctorProfileImageUrl,
            ),
            Expanded(child: ChatRoomListBody(
              doctorId: doctorId,
              currentUserId: currentUserId,
              doctorName: doctorName,
              doctorProfileImageUrl: doctorProfileImageUrl,
            )),
          ],
        ),
      ),
    );
  }
}
