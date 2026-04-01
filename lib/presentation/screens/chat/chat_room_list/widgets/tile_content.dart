import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/tile_header.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/tile_preview.dart';

class TileContent extends StatelessWidget {
  final ChatRoomModel room;
  final String patientName;
  final bool hasUnread;
  final String currentUserId;

  const TileContent({
    required this.room,
    required this.patientName,
    required this.hasUnread,
    required this.currentUserId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TileHeader(
          patientName: patientName,
          hasUnread: hasUnread,
          lastMessageTime: room.lastMessageTime,
        ),
        const SizedBox(height: 4),
        TilePreview(
          room: room,
          hasUnread: hasUnread,
          currentUserId: currentUserId,
        ),
      ],
    );
  }
}