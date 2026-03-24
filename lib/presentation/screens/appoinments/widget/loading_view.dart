import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab skeleton
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE8F0F7),
            highlightColor: const Color(0xFFF5F9FF),
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Date header skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: const Color(0xFFE8F0F7),
            highlightColor: const Color(0xFFF5F9FF),
            child: Row(
              children: [
                _bone(h: 26, w: 80, r: 20),
                const SizedBox(width: 10),
                _bone(h: 1, w: 200, r: 0),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Card skeletons
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 4,
            itemBuilder: (_, i) => _CardSkeleton(index: i),
          ),
        ),
      ],
    );
  }
}

Widget _bone({
  required double h,
  required double w,
  required double r,
}) {
  return Container(
    height: h,
    width: w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(r),
    ),
  );
}

class _CardSkeleton extends StatelessWidget {
  final int index;

  const _CardSkeleton({required this.index});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE8F0F7),
      highlightColor: const Color(0xFFF5F9FF),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // stripe
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Patient row
                  Row(
                    children: [
                      _bone(h: 56, w: 56, r: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _bone(h: 14, w: double.infinity, r: 6),
                            const SizedBox(height: 8),
                            _bone(h: 12, w: 100, r: 6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _bone(h: 26, w: 76, r: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Divider
                  _bone(h: 1, w: double.infinity, r: 0),
                  const SizedBox(height: 14),
                  // Meta chips
                  Row(
                    children: [
                      _bone(h: 30, w: 90, r: 10),
                      const SizedBox(width: 8),
                      _bone(h: 30, w: 80, r: 10),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Action row
                  _bone(h: 40, w: double.infinity, r: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}