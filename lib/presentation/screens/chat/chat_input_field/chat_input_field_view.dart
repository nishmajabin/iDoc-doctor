
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/cubits/chat/chat_input_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_input_field/widget/chat_send_button.dart';

class ChatInputFieldView extends StatelessWidget {
  final void Function(String text) onSend;
  final bool isSending;

  const ChatInputFieldView({
    required this.onSend,
    required this.isSending,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChatInputCubit>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.gradientColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<ChatInputCubit, bool>(
          builder: (context, hasText) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFDDE4EE),
                      ),
                    ),
                    child: TextField(
                      controller: cubit.controller,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF1A2332),
                        fontFamily: 'Nunito',
                        height: 1.4,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message…',
                        hintStyle: TextStyle(
                          color: Color(0xFFA8B6C8),
                          fontSize: 15,
                          fontFamily: 'Nunito',
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) {
                        if (hasText && !isSending) cubit.send(onSend);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ChatSendButton(
                  hasText: hasText,
                  isSending: isSending,
                  onTap: hasText && !isSending
                      ? () => cubit.send(onSend)
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}