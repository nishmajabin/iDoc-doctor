import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/chat_theme.dart';

class ChatRoomAvatar extends StatelessWidget {
  final String? avatarUrl;

  final String? initial;

  final double size;

  const ChatRoomAvatar({
    super.key,
    this.avatarUrl,
    this.initial,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            ChatColors.avatarGradientStart,
            ChatColors.avatarGradientEnd,
          ],
        ),
      ),
      child: ClipOval(child: _content),
    );
  }

  Widget get _content {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return Image.network(avatarUrl!, fit: BoxFit.cover);
    }

    if (initial != null && initial!.isNotEmpty) {
      return Center(
        child: Text(
          initial![0].toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
      );
    }

    return const Icon(Icons.person, color: Colors.white);
  }
}
