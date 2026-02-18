import 'package:flutter/material.dart';

class ChatShimmerLoading extends StatefulWidget {
  const ChatShimmerLoading({super.key});

  @override
  State<ChatShimmerLoading> createState() => _ChatShimmerLoadingState();
}

class _ChatShimmerLoadingState extends State<ChatShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 7,
      itemBuilder: (context, index) {
        final isRight = index % 3 != 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          child: Row(
            mainAxisAlignment:
                isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isRight) ...[
                _ShimmerBox(width: 30, height: 30, borderRadius: 15, animation: _animation),
                const SizedBox(width: 8),
              ],
              _ShimmerBox(
                width: isRight ? 180 + (index * 12.0 % 60) : 140 + (index * 15.0 % 80),
                height: 48 + (index * 4.0 % 24),
                borderRadius: 18,
                animation: _animation,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Animation<double> animation;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (animation.value - 1).clamp(0.0, 1.0),
                animation.value.clamp(0.0, 1.0),
                (animation.value + 1).clamp(0.0, 1.0),
              ],
              colors: const [
                Color(0xFFEEF2F7),
                Color(0xFFD8E2EE),
                Color(0xFFEEF2F7),
              ],
            ),
          ),
        );
      },
    );
  }
}