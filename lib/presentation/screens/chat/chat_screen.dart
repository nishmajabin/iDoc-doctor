import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/app_const.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:idoc_doctor_side/data/repositories/call_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/call/call_event.dart';
import 'package:idoc_doctor_side/presentation/screens/call/video_call_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_bubble.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_input_field.dart';
import 'package:idoc_doctor_side/presentation/screens/chat/chat_shimmer_loading.dart';
import 'package:intl/intl.dart';
import 'package:idoc_doctor_side/data/models/chat_message_model.dart';
import 'package:idoc_doctor_side/data/repositories/chat_repository.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_event.dart';
import 'package:idoc_doctor_side/logic/blocs/chat/chat_state.dart';

class ChatScreen extends StatelessWidget {
  final String doctorId;
  final String patientId;       // patient's Firebase Auth UID
  final String appointmentId;
  final String currentUserId;
  final bool currentUserIsDoctor;
  final String? doctorName;
  final String? patientName;
  final String? doctorProfileImageUrl;
  final String? patientProfileImageUrl;

  const ChatScreen({
    super.key,
    required this.doctorId,
    required this.patientId,
    required this.appointmentId,
    required this.currentUserId,
    required this.currentUserIsDoctor,
    this.doctorName,
    this.patientName,
    this.doctorProfileImageUrl,
    this.patientProfileImageUrl,
  });

  static Route<void> route({
    required String doctorId,
    required String patientId,
    required String appointmentId,
    required String currentUserId,
    required bool currentUserIsDoctor,
    String? doctorName,
    String? patientName,
    String? doctorProfileImageUrl,
    String? patientProfileImageUrl,
  }) {
    return MaterialPageRoute(
      builder: (_) => ChatScreen(
        doctorId: doctorId,
        patientId: patientId,
        appointmentId: appointmentId,
        currentUserId: currentUserId,
        currentUserIsDoctor: currentUserIsDoctor,
        doctorName: doctorName,
        patientName: patientName,
        doctorProfileImageUrl: doctorProfileImageUrl,
        patientProfileImageUrl: patientProfileImageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(repository: ChatRepository())
        ..add(
          InitializeChatRoom(
            doctorId: doctorId,
            patientId: patientId,
            appointmentId: appointmentId,
            currentUserId: currentUserId,
            currentUserIsDoctor: currentUserIsDoctor,
            doctorName: doctorName,
            patientName: patientName,
            doctorProfileImageUrl: doctorProfileImageUrl,
            patientProfileImageUrl: patientProfileImageUrl,
          ),
        ),
      child: _ChatView(
        currentUserIsDoctor: currentUserIsDoctor,
        otherName: currentUserIsDoctor
            ? (patientName ?? 'Patient')
            : (doctorName ?? 'Doctor'),
        otherAvatarUrl: currentUserIsDoctor
            ? patientProfileImageUrl
            : doctorProfileImageUrl,
        appointmentId: appointmentId,
        patientName: patientName ?? 'Patient',
        // ── All fields needed for video call signaling ──────────────────
        doctorId: doctorId,
        patientUserId: patientId,                   // patient's Firebase uid
        doctorName: doctorName ?? 'Doctor',
        doctorProfileImageUrl: doctorProfileImageUrl,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ChatView extends StatefulWidget {
  final bool currentUserIsDoctor;
  final String otherName;
  final String? otherAvatarUrl;

  // Video call fields — threaded from ChatScreen
  final String appointmentId;
  final String patientName;
  final String doctorId;
  final String patientUserId;
  final String doctorName;
  final String? doctorProfileImageUrl;

  const _ChatView({
    required this.currentUserIsDoctor,
    required this.otherName,
    this.otherAvatarUrl,
    required this.appointmentId,
    required this.patientName,
    required this.doctorId,
    required this.patientUserId,
    required this.doctorName,
    this.doctorProfileImageUrl,
  });

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendMessage(text));
    _messageController.clear();
    _scrollToBottom();
  }

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
            _ChatAppBar(
              name: widget.otherName,
              avatarUrl: widget.otherAvatarUrl,
              isDoctor: !widget.currentUserIsDoctor,
              appointmentId: widget.appointmentId,
              patientName: widget.patientName,
              doctorId: widget.doctorId,
              patientUserId: widget.patientUserId,
              doctorName: widget.doctorName,
              doctorProfileImageUrl: widget.doctorProfileImageUrl,
            ),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listenWhen: (prev, curr) =>
                    curr is ChatLoaded &&
                    prev is ChatLoaded &&
                    curr.messages.length != prev.messages.length,
                listener: (context, state) {
                  if (state is ChatLoaded) _scrollToBottom();
                },
                builder: (context, state) {
                  if (state is ChatLoading || state is ChatInitial) {
                    return const ChatShimmerLoading();
                  }
                  if (state is ChatError) {
                    return _ErrorState(message: state.message);
                  }
                  if (state is ChatLoaded) {
                    if (state.messages.isEmpty) return const _EmptyState();
                    return _MessageList(
                      messages: state.messages,
                      currentUserId: state.currentUserId,
                      scrollController: _scrollController,
                      otherAvatarUrl: widget.otherAvatarUrl,
                      otherName: widget.otherName,
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
                  controller: _messageController,
                  onSend: _sendMessage,
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

// ── App Bar ───────────────────────────────────────────────────────────────────

class _ChatAppBar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final bool isDoctor;
  final String appointmentId;
  final String patientName;
  final String doctorId;
  final String patientUserId;
  final String doctorName;
  final String? doctorProfileImageUrl;

  const _ChatAppBar({
    required this.name,
    this.avatarUrl,
    required this.isDoctor,
    required this.appointmentId,
    required this.patientName,
    required this.doctorId,
    required this.patientUserId,
    required this.doctorName,
    this.doctorProfileImageUrl,
  });

  Future<void> _startVideoCall(BuildContext context) async {
    // ── 1. Request permissions ───────────────────────────────────────────────
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    final granted = statuses.values.every((s) => s.isGranted);

    // ── 2. Guard against async gap — widget may have unmounted ───────────────
    if (!context.mounted) return;

    if (!granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera and microphone permissions are required.'),
        ),
      );
      return;
    }

    // ── 3. Navigate — all data is captured in closure, no context stored ─────
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => CallBloc(
            repository: CallRepository(),
            channelName: appointmentId,
            doctorId: doctorId,
            patientUserId: patientUserId, // patient's Firebase Auth UID
            doctorName: doctorName,
            patientName: patientName,
            doctorProfileImageUrl: doctorProfileImageUrl,
          )..add(
              CallJoinRequested(
                channelName: appointmentId,
                appId: AppConstants.agoraAppId,
              ),
            ),
          child: VideoCallScreen(
            channelName: appointmentId,
            patientName: patientName,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
          top: topPadding + 8, bottom: 12, left: 4, right: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A6B6A), Color(0xFF0E7C7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E7C7B).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withOpacity(0.3), width: 2),
              color: Colors.white.withOpacity(0.15),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _AvatarFallback(name: name),
                    )
                  : _AvatarFallback(name: name),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Nunito',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF7FFFDD),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      isDoctor ? 'Doctor' : 'Patient',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Video call button — only shown when doctor is chatting
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => _startVideoCall(context),
              icon: const Icon(Icons.videocam_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String name;
  const _AvatarFallback({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.2),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Nunito',
          ),
        ),
      ),
    );
  }
}

// ── Message List ──────────────────────────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final List<ChatMessageModel> messages;
  final String currentUserId;
  final ScrollController scrollController;
  final String? otherAvatarUrl;
  final String otherName;

  const _MessageList({
    required this.messages,
    required this.currentUserId,
    required this.scrollController,
    this.otherAvatarUrl,
    required this.otherName,
  });

  @override
  Widget build(BuildContext context) {
    final items = <_ChatListItem>[];
    DateTime? lastDate;

    for (final msg in messages) {
      final msgDate = DateTime(
        msg.timestamp.year,
        msg.timestamp.month,
        msg.timestamp.day,
      );
      if (lastDate == null || !lastDate.isAtSameMomentAs(msgDate)) {
        items.add(_ChatListItem.dateSeparator(msgDate));
        lastDate = msgDate;
      }
      items.add(_ChatListItem.message(msg));
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item.isDateSeparator) {
          return _DateSeparator(date: item.date!);
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

class _DateSeparator extends StatelessWidget {
  final DateTime date;
  const _DateSeparator({required this.date});

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 20, right: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFCDD8E8).withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EFF8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatDate(date),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B80A0),
                fontFamily: 'Nunito',
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 12, right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFCDD8E8).withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty / Error States ──────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0E7C7B).withOpacity(0.1),
                    const Color(0xFF27C4C3).withOpacity(0.08),
                  ],
                ),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: Color(0xFF0E7C7B),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start the Conversation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to begin your\nconsultation session.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF1A2332).withOpacity(0.5),
                fontFamily: 'Nunito',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 48, color: Color(0xFFE05C5C)),
            const SizedBox(height: 16),
            const Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2332),
                fontFamily: 'Nunito',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF1A2332).withOpacity(0.5),
                fontFamily: 'Nunito',
              ),
            ),
          ],
        ),
      ),
    );
  }
}