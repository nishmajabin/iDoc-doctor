import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/shimmer_card.dart';
import 'package:idoc_doctor_side/presentation/screens/appoinments/widget/tab_skeleton.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const TabSkeleton(),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 5,
            itemBuilder: (_, __) => const ShimmerCard(),
          ),
        ),
      ],
    );
  }
}
