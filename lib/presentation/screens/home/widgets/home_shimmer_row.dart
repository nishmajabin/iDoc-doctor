import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:shimmer/shimmer.dart';

class HomeShimmerRow extends StatelessWidget {
  const HomeShimmerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 182,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder:
            (_, i) => Padding(
              padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
              child: Shimmer.fromColors(
                baseColor: AppColors.shimmerBase,
                highlightColor: AppColors.shimmerHighlight,
                child: Container(
                  width: 154,
                  decoration: BoxDecoration(
                    color: AppColors.gradientColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration:  BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.bgColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 90,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 70,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.bgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}