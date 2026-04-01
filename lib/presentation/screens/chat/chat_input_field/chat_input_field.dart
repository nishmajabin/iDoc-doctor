import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/chat/chat_input_cubit.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_input_field/chat_input_field_view.dart';

class ChatInputField extends StatelessWidget {
  final void Function(String text) onSend;
  final bool isSending;

  const ChatInputField({
    super.key,
    required this.onSend,
    this.isSending = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatInputCubit(),
      child: ChatInputFieldView(onSend: onSend, isSending: isSending),
    );
  }
}
