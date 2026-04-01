import 'package:flutter/material.dart';
import 'shimmer_box.dart';

class ChatShimmerItem extends StatelessWidget {
  final int index;

  const ChatShimmerItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isRight = index % 3 != 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        mainAxisAlignment:
            isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isRight) ...[
            const ShimmerBox(width: 30, height: 30, borderRadius: 15),
            const SizedBox(width: 8),
          ],
          ShimmerBox(
            width: isRight
                ? 180 + (index * 12.0 % 60)
                : 140 + (index * 15.0 % 80),
            height: 48 + (index * 4.0 % 24),
            borderRadius: 18,
          ),
        ],
      ),
    );
  }
}