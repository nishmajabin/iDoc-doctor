import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/chat_room_model.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/tile_card.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/chat_screen.dart';
import 'package:intl/intl.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final String currentUserId;
  final String doctorId;
  final String? doctorName;
  final String? doctorProfileImageUrl;

  const ChatRoomTile({
    super.key,
    required this.room,
    required this.currentUserId,
    required this.doctorId,
    this.doctorName,
    this.doctorProfileImageUrl,
  });

  static String formatTime(DateTime? time) {
    if (time == null) return '';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return DateFormat('hh:mm a').format(time);
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(time);
  }

  void _navigateToChat(BuildContext context, String patientName) {
    Navigator.of(context).push(
      ChatScreen.route(
        doctorId: doctorId,
        patientId: room.patientId,
        appointmentId: room.appointmentId,
        currentUserId: currentUserId,
        currentUserIsDoctor: true,
        doctorName: doctorName,
        patientName: patientName,
        doctorProfileImageUrl: doctorProfileImageUrl,
        patientProfileImageUrl: room.patientProfileImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = room.unreadCountDoctor;
    final hasUnread = unreadCount > 0;
    final patientName = room.patientName ?? 'Patient';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToChat(context, patientName),
          borderRadius: BorderRadius.circular(16),
          child: TileCard(
            room: room,
            patientName: patientName,
            hasUnread: hasUnread,
            unreadCount: unreadCount,
            currentUserId: currentUserId,
          ),
        ),
      ),
    );
  }
}


