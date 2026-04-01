
import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_room_tile.dart';

class TileHeader extends StatelessWidget {
  final String patientName;
  final bool hasUnread;
  final DateTime? lastMessageTime;

  const TileHeader({
    required this.patientName,
    required this.hasUnread,
    required this.lastMessageTime,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          patientName,
          style: hasUnread
              ? ChatTextStyles.roomNameUnread
              : ChatTextStyles.roomName,
        ),
        Text(
          ChatRoomTile.formatTime(lastMessageTime),
          style: TextStyle(
            fontSize: 11,
            color: hasUnread ? ChatColors.primary : ChatColors.textSecondary,
            fontWeight:
                hasUnread ? FontWeight.w600 : FontWeight.normal,
            fontFamily: 'Nunito',
          ),
        ),
      ],
    );
  }
}