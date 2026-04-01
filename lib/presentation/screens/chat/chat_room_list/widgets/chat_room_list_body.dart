import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat_room_list.dart/chat_room_list_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat_room_list.dart/chat_room_list_state.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_error_view.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_room_list_placeholders.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_room_list/widgets/chat_room_tile.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/shimmer/chat_shimmer_loading.dart';

class ChatRoomListBody extends StatelessWidget {
  final String doctorId;
  final String currentUserId;
  final String? doctorName;
  final String? doctorProfileImageUrl;

  const ChatRoomListBody({
    required this.doctorId,
    required this.currentUserId,
    this.doctorName,
    this.doctorProfileImageUrl,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomListBloc, ChatRoomListState>(
      builder: (context, state) => switch (state) {
        ChatRoomListInitial() || ChatRoomListLoading() =>
          const ChatShimmerLoading(),

        ChatRoomListError(:final message) =>
          ChatErrorView(message: message),

        ChatRoomListLoaded(:final rooms) when rooms.isEmpty =>
          const EmptyInboxView(),

        ChatRoomListLoaded(:final rooms) => ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            itemCount: rooms.length,
            itemBuilder: (context, index) => ChatRoomTile(
              room: rooms[index],
              currentUserId: currentUserId,
              doctorId: doctorId,
              doctorName: doctorName,
              doctorProfileImageUrl: doctorProfileImageUrl,
            ),
          ),
      },
    );
  }
}