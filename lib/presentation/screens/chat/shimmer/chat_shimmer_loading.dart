import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/cubits/shimmer/shimmer_cubit.dart';
import 'chat_shimmer_item.dart';

class ChatShimmerLoading extends StatelessWidget {
  const ChatShimmerLoading({super.key});

  static const int _itemCount = 7;

  @override
  Widget build(BuildContext context) {
    // Single cubit shared across all shimmer boxes — one timer, perfect sync.
    return BlocProvider(
      create: (_) => ShimmerCubit(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _itemCount,
        itemBuilder: (context, index) => ChatShimmerItem(index: index),
      ),
    );
  }
}