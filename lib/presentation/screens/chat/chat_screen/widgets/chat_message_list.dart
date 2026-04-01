import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_bubble/chat_bubble.dart';
import 'chat_date_separator.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessageModel> messages;
  final String currentUserId;
  final ScrollController scrollController;
  final String? otherAvatarUrl;
  final String otherName;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
    this.otherAvatarUrl,
    required this.otherName,
  });

  List<_ChatListItem> _buildItems() {
    final items = <_ChatListItem>[];
    DateTime? lastDate;

    for (final msg in messages) {
      final msgDate =
          DateTime(msg.timestamp.year, msg.timestamp.month, msg.timestamp.day);
      if (lastDate == null || !lastDate.isAtSameMomentAs(msgDate)) {
        items.add(_ChatListItem.dateSeparator(msgDate));
        lastDate = msgDate;
      }
      items.add(_ChatListItem.message(msg));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.isDateSeparator) {
          return ChatDateSeparator(date: item.date!);
        }
        final msg = item.message!;
        final isSentByMe = msg.senderId == currentUserId;
        return ChatBubble(
          message: msg,
          isSentByMe: isSentByMe,
          showAvatar: !isSentByMe,
          avatarUrl: otherAvatarUrl,
          senderInitial: otherName.isNotEmpty ? otherName[0] : '?',
        );
      },
    );
  }
}

class _ChatListItem {
  final bool isDateSeparator;
  final DateTime? date;
  final ChatMessageModel? message;

  const _ChatListItem._({
    required this.isDateSeparator,
    this.date,
    this.message,
  });

  factory _ChatListItem.dateSeparator(DateTime date) =>
      _ChatListItem._(isDateSeparator: true, date: date);

  factory _ChatListItem.message(ChatMessageModel msg) =>
      _ChatListItem._(isDateSeparator: false, message: msg);
}