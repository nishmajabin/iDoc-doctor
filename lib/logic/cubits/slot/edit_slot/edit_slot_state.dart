import 'package:flutter/material.dart';

class EditSlotState {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const EditSlotState({
    required this.startTime,
    required this.endTime,
  });

  EditSlotState copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return EditSlotState(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}