import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat_room_list.dart/chat_room_list_bloc.dart';

import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:idoc_doctor_side/data/models/chat_room_model.dart';
import 'package:idoc_doctor_side/data/repositories/chat_repository.dart';

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
      child: _ChatRoomListView(
        doctorId: doctorId,
        currentUserId: currentUserId,
        doctorName: doctorName,
        doctorProfileImageUrl: doctorProfileImageUrl,
      ),
    );
  }
}

class _ChatRoomListView extends StatelessWidget {
  final String doctorId;
  final String currentUserId;
  final String? doctorName;
  final String? doctorProfileImageUrl;

  const _ChatRoomListView({
    required this.doctorId,
    required this.currentUserId,
    this.doctorName,
    this.doctorProfileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FC),
        body: Column(
          children: [
            _ListAppBar(
              doctorName: doctorName,
              avatarUrl: doctorProfileImageUrl,
            ),
            Expanded(
              child: BlocBuilder<ChatRoomListBloc, ChatRoomListState>(
                builder: (context, state) {
                  if (state is ChatRoomListLoading ||
                      state is ChatRoomListInitial) {
                    return const ChatShimmerLoading();
                  }

                  if (state is ChatRoomListError) {
                    return _ErrorView(message: state.message);
                  }

                  if (state is ChatRoomListLoaded) {
                    if (state.rooms.isEmpty) {
                      return const _EmptyInboxView();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      itemCount: state.rooms.length,
                      itemBuilder: (context, index) {
                        return _ChatRoomTile(
                          room: state.rooms[index],
                          currentUserId: currentUserId,
                          doctorId: doctorId,
                          doctorName: doctorName,
                          doctorProfileImageUrl: doctorProfileImageUrl,
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────

class _ListAppBar extends StatelessWidget {
  final String? doctorName;
  final String? avatarUrl;

  const _ListAppBar({this.doctorName, this.avatarUrl});

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
          colors: [Color(0xFF0A6B6A), Color(0xFF0E7C7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Nunito',
                  ),
                ),
                Text(
                  'Patient consultations',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontFamily: 'Nunito',
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? Image.network(avatarUrl!, fit: BoxFit.cover)
                  : Container(
                      color: Colors.white.withOpacity(0.15),
                      child: const Icon(Icons.person, color: Colors.white, size: 22),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat Room Tile ───────────────────────────────────────────────────────────

class _ChatRoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final String currentUserId;
  final String doctorId;
  final String? doctorName;
  final String? doctorProfileImageUrl;

  const _ChatRoomTile({
    required this.room,
    required this.currentUserId,
    required this.doctorId,
    this.doctorName,
    this.doctorProfileImageUrl,
  });

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return DateFormat('hh:mm a').format(time);
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = room.unreadCountDoctor;
    final hasUnread = unreadCount > 0;
    final patientName = room.patientName ?? 'Patient';
    final avatarUrl = room.patientProfileImageUrl;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
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
                patientProfileImageUrl: avatarUrl,
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: hasUnread
                  ? Border.all(
                      color: const Color(0xFF0E7C7B).withOpacity(0.15),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF78D8D7), Color(0xFF27C4C3)],
                        ),
                      ),
                      child: ClipOval(
                        child: avatarUrl != null && avatarUrl.isNotEmpty
                            ? Image.network(avatarUrl, fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  patientName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                      ),
                    ),
                    if (hasUnread)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF0E7C7B),
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 9 ? '9+' : '$unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            patientName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: hasUnread
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              color: const Color(0xFF1A2332),
                              fontFamily: 'Nunito',
                            ),
                          ),
                          Text(
                            _formatTime(room.lastMessageTime),
                            style: TextStyle(
                              fontSize: 11,
                              color: hasUnread
                                  ? const Color(0xFF0E7C7B)
                                  : const Color(0xFF8A9BB0),
                              fontWeight: hasUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (room.lastMessageSenderId == currentUserId)
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.done_all,
                                size: 14,
                                color: hasUnread
                                    ? const Color(0xFF0E7C7B)
                                    : const Color(0xFF8A9BB0),
                              ),
                            ),
                          Expanded(
                            child: Text(
                              room.lastMessage ?? 'Start a conversation',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: hasUnread
                                    ? const Color(0xFF1A2332)
                                    : const Color(0xFF8A9BB0),
                                fontWeight: hasUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                fontFamily: 'Nunito',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty / Error ────────────────────────────────────────────────────────────

class _EmptyInboxView extends StatelessWidget {
  const _EmptyInboxView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0E7C7B).withOpacity(0.08),
              ),
              child: const Icon(
                Icons.inbox_rounded,
                size: 44,
                color: Color(0xFF0E7C7B),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Messages Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Patient conversations will appear\nhere after appointments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF1A2332).withOpacity(0.5),
                height: 1.5,
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFFE05C5C), fontFamily: 'Nunito'),
        textAlign: TextAlign.center,
      ),
    );
  }
}