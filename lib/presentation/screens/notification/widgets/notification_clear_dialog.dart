import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_event.dart';

/// Extracted dialog — keeps NotificationHeader free of dialog logic.
void showClearAllDialog(BuildContext context, {required String? doctorId}) {
  if (doctorId == null) return;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Clear All Notifications'),
      content: const Text(
        'Are you sure you want to delete all notifications? '
        'This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Use the outer context's bloc — ctx (dialog context) may not have it.
            context.read<NotificationHistoryBloc>().add(
                  ClearAllNotifications(doctorId: doctorId),
                );
            Navigator.pop(ctx);
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.cancelled),
          child: const Text('Clear All'),
        ),
      ],
    ),
  );
}