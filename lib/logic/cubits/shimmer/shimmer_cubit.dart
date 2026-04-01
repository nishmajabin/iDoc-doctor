import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShimmerCubit extends Cubit<double> {
  static const Duration _duration = Duration(milliseconds: 1400);
  static const int _ticksPerCycle = 60;

  Timer? _timer;

  ShimmerCubit() : super(0.0) {
    _start();
  }

  void _start() {
    final interval = Duration(
      microseconds: _duration.inMicroseconds ~/ _ticksPerCycle,
    );

    _timer = Timer.periodic(interval, (_) {
      final next = (state + 1 / _ticksPerCycle) % 1.0;
      emit(next);
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}