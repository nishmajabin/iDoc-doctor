import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';

class TilePreview extends StatelessWidget {
  final ChatRoomModel room;
  final bool hasUnread;
  final String currentUserId;

  const TilePreview({
    required this.room,
    required this.hasUnread,
    required this.currentUserId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final isSender = room.lastMessageSenderId == currentUserId;

    return Row(
      children: [
        if (isSender)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              Icons.done_all,
              size: 14,
              color: hasUnread ? ChatColors.primary : ChatColors.textSecondary,
            ),
          ),
        Expanded(
          child: Text(
            room.lastMessage ?? 'Start a conversation',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: hasUnread
                ? ChatTextStyles.roomPreviewUnread
                : ChatTextStyles.roomPreview,
          ),
        ),
      ],
    );
  }
}