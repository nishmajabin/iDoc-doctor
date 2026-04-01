import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/notification/notification_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification/notification_state.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_state.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_bloc.dart';
import 'empty_or_error_view.dart';
import 'notification_list.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  static const _emptyView = EmptyOrErrorView(
    icon: Icons.notifications_off_rounded,
    title: 'No notifications yet',
    subtitle:
        "You'll see appointment bookings,\nchat messages, and reminders here.",
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationHistoryBloc, NotificationHistoryState>(
      builder: (context, state) => switch (state) {
        NotificationHistoryLoading() => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        NotificationHistoryError(:final message) => EmptyOrErrorView(
            icon: Icons.error_outline_rounded,
            title: 'Something went wrong',
            subtitle: message,
          ),
        NotificationHistoryLoaded(:final notifications)
            when notifications.isEmpty =>
          _emptyView,
        NotificationHistoryLoaded(:final notifications) =>
          NotificationList(
            notifications: notifications,
            // Safely read doctorId from NotificationBloc.
            doctorId: switch (context.read<NotificationBloc>().state) {
              NotificationReady(:final doctorId) => doctorId,
              _ => '',
            },
          ),
        _ => _emptyView,
      },
    );
  }
}