import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_room_avatar.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/unread_badge.dart';

class AvatarWithBadge extends StatelessWidget {
  final String? avatarUrl;
  final String patientName;
  final bool hasUnread;
  final int unreadCount;

  const AvatarWithBadge({
    required this.avatarUrl,
    required this.patientName,
    required this.hasUnread,
    required this.unreadCount,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ChatRoomAvatar(avatarUrl: avatarUrl, initial: patientName),
        if (hasUnread)
          Positioned(
            right: 0,
            top: 0,
            child: UnreadBadge(count: unreadCount),
          ),
      ],
    );
  }
}
