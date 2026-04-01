import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/appbar_text.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/doctor_avatarr.dart';

class ChatRoomListAppBar extends StatelessWidget {
  final String? doctorName;
  final String? avatarUrl;

  const ChatRoomListAppBar({
    super.key,
    this.doctorName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 12,
        bottom: 16,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [ChatColors.primaryDark, ChatColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          const Expanded(child: AppBarText()),
          DoctorAvatar(avatarUrl: avatarUrl),
        ],
      ),
    );
  }
}



