import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:idoc_doctor_side/data/models/chat_message_model.dart';

class ChatBubble extends StatefulWidget {
  final ChatMessageModel message;
  final bool isSentByMe;
  final bool showAvatar;
  final String? avatarUrl;
  final String? senderInitial;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    this.showAvatar = false,
    this.avatarUrl,
    this.senderInitial,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.isSentByMe ? 0.3 : -0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: Row(
            mainAxisAlignment: widget.isSentByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!widget.isSentByMe) ...[
                _Avatar(
                  url: widget.avatarUrl,
                  initial: widget.senderInitial ?? '?',
                  isDoctor: true,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(child: _Bubble(message: widget.message, isSentByMe: widget.isSentByMe)),
              if (widget.isSentByMe) const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isSentByMe;

  const _Bubble({required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    // Sent (doctor) — deep teal gradient
    // Received (patient) — soft white card
    final sentGradient = const LinearGradient(
      colors: [Color(0xFF0E7C7B), Color(0xFF1A9E9D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.68,
      ),
      decoration: BoxDecoration(
        gradient: isSentByMe ? sentGradient : null,
        color: isSentByMe ? null : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(isSentByMe ? 20 : 4),
          bottomRight: Radius.circular(isSentByMe ? 4 : 20),
        ),
        boxShadow: [
          BoxShadow(
            color: isSentByMe
                ? const Color(0xFF0E7C7B).withOpacity(0.25)
                : Colors.black.withOpacity(0.07),
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
              color: isSentByMe ? Colors.white : const Color(0xFF1A2332),
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('hh:mm a').format(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: isSentByMe
                      ? Colors.white.withOpacity(0.7)
                      : const Color(0xFF8A9BB0),
                  fontFamily: 'Nunito',
                ),
              ),
              if (isSentByMe) ...[
                const SizedBox(width: 4),
                Icon(
                  message.isRead ? Icons.done_all : Icons.done,
                  size: 13,
                  color: message.isRead
                      ? Colors.white
                      : Colors.white.withOpacity(0.6),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final String initial;
  final bool isDoctor;

  const _Avatar({this.url, required this.initial, required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF0E7C7B), Color(0xFF27C4C3)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E7C7B).withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: url != null && url!.isNotEmpty
          ? ClipOval(
              child: Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _Initial(initial: initial),
              ),
            )
          : _Initial(initial: initial),
    );
  }
}

class _Initial extends StatelessWidget {
  final String initial;
  const _Initial({required this.initial});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initial.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          fontFamily: 'Nunito',
        ),
      ),
    );
  }
}