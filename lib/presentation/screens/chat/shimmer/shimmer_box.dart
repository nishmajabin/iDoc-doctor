import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/shimmer/shimmer_cubit.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShimmerCubit, double>(
      builder: (context, progress) {
        final sweep = progress * 3 - 1;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (sweep - 1).clamp(0.0, 1.0),
                sweep.clamp(0.0, 1.0),
                (sweep + 1).clamp(0.0, 1.0),
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