import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';
import 'package:intl/intl.dart';

class TimeRow extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSentByMe;

  const TimeRow({required this.message, required this.isSentByMe, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('hh:mm a').format(message.timestamp),
          style: TextStyle(
            fontSize: 10,
            color: isSentByMe
                ? Colors.white.withValues(alpha: 0.7)
                : const Color(0xFF8A9BB0),
            fontFamily: 'Nunito',
          ),
        ),
        if (isSentByMe) ...[
          const SizedBox(width: 4),
          Icon(
            message.isRead ? Icons.done_all : Icons.done,
            size: 13,
            color:
                message.isRead ? Colors.white : Colors.white.withValues(alpha: 0.6),
          ),
        ],
      ],
    );
  }
}