import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_bubble/widgets/time_row.dart';
import 'package:idoc_doctor_side/core/data/models/chat_message_model.dart';

class ChatBubbleContent extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSentByMe;

  static const _sentGradient = LinearGradient(
    colors: [AppColors.chatSendColor,AppColors.chatSendColorGradient ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  const ChatBubbleContent({
    required this.message,
    required this.isSentByMe,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.68,
      ),
      decoration: BoxDecoration(
        gradient: isSentByMe ? _sentGradient : null,
        color: isSentByMe ? null : AppColors.gradientColor,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
          bottomRight: Radius.circular(isSentByMe ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: isSentByMe
                ? AppColors.chatSendColor.withValues(alpha: 0.25)
                : AppColors.textPrimary.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.messageText,
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: isSentByMe ? AppColors.gradientColor :AppColors.userChatTextColor,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 4),
          TimeRow(message: message, isSentByMe: isSentByMe),
        ],
      ),
    );
  }
}