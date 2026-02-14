import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/doctor/available_time/create_slots/widgets/time_selector.dart';

class TimeSelectorWidget extends StatelessWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final Future<void> Function({required bool isStart}) onSelectTime;

  const TimeSelectorWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onSelectTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TimeSelector(
              label: 'Start Time',
              time: startTime,
              onTap: () => onSelectTime(isStart: true),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'to',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TimeSelector(
              label: 'End Time',
              time: endTime,
              onTap: () => onSelectTime(isStart: false),
            ),
          ),
        ],
      ),
    );
  }
}

