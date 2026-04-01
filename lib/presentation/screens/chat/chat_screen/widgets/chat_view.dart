
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_event.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_state.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_input_field/chat_input_field.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/widgets/chat_app_bar.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/widgets/chat_error_state.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/widgets/chat_message_list.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_screen/widgets/chat_states_ui.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/shimmer/chat_shimmer_loading.dart';

class ChatView extends StatelessWidget {
  final bool currentUserIsDoctor;
  final String otherName;
  final String? otherAvatarUrl;
  final String appointmentId;
  final String patientName;
  final String doctorId;
  final String patientUserId;
  final String doctorName;
  final String? doctorProfileImageUrl;

  final ScrollController _scrollController = ScrollController();

  ChatView({
    required this.currentUserIsDoctor,
    required this.otherName,
    this.otherAvatarUrl,
    required this.appointmentId,
    required this.patientName,
    required this.doctorId,
    required this.patientUserId,
    required this.doctorName,
    this.doctorProfileImageUrl,
    super.key
  });

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FC),
        body: Column(
          children: [
            ChatAppBar(
              name: otherName,
              avatarUrl: otherAvatarUrl,
              isDoctor: !currentUserIsDoctor,
              appointmentId: appointmentId,
              patientName: patientName,
              doctorId: doctorId,
              patientUserId: patientUserId,
              doctorName: doctorName,
              doctorProfileImageUrl: doctorProfileImageUrl,
            ),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listenWhen: (prev, curr) =>
                    curr is ChatLoaded &&
                    prev is ChatLoaded &&
                    curr.messages.length != prev.messages.length,
                listener: (_, state) {
                  if (state is ChatLoaded) _scrollToBottom();
                },
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatInitial) {
                    return const ChatShimmerLoading();
                  }
                  if (state is ChatError) {
                    return ChatErrorState(message: state.message);
                  }
                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) return const ChatEmptyState();
                    return ChatMessageList(
                      messages: state.messages,
                      currentUserId: state.currentUserId,
                      scrollController: _scrollController,
                      otherAvatarUrl: otherAvatarUrl,
                      otherName: otherName,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocBuilder<ChatBloc, ChatState>(
              buildWhen: (prev, curr) =>
                  (prev is ChatLoaded &&
                      curr is ChatLoaded &&
                      prev.isSending != curr.isSending) ||
                  prev.runtimeType != curr.runtimeType,
              builder: (context, state) {
                final isSending =
                    state is ChatLoaded ? state.isSending : false;
                return ChatInputField(
                  onSend: (text) =>
                      context.read<ChatBloc>().add(SendMessage(text)),
                  isSending: isSending,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}