import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/avatar_with_badge.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/tile_content.dart';

class TileCard extends StatelessWidget {
  final ChatRoomModel room;
  final String patientName;
  final bool hasUnread;
  final int unreadCount;
  final String currentUserId;

  const TileCard({
    required this.room,
    required this.patientName,
    required this.hasUnread,
    required this.unreadCount,
    required this.currentUserId,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.gradientColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: hasUnread
            ? Border.all(
                color: ChatColors.primary.withValues(alpha: 0.15),
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          AvatarWithBadge(
            avatarUrl: room.patientProfileImageUrl,
            patientName: patientName,
            hasUnread: hasUnread,
            unreadCount: unreadCount,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TileContent(
              room: room,
              patientName: patientName,
              hasUnread: hasUnread,
              currentUserId: currentUserId,
            ),
          ),
        ],
      ),
    );
  }
}