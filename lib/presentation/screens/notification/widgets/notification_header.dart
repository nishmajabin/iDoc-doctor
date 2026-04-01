import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification/notification_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification/notification_state.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_event.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_state.dart';
import 'header_action_button.dart';
import 'notification_clear_dialog.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({super.key});

  String? _doctorId(BuildContext context) {
    final state = context.read<NotificationBloc>().state;
    return state is NotificationReady ? state.doctorId : null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.notifications_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  BlocBuilder<NotificationHistoryBloc, NotificationHistoryState>(
                    buildWhen: (prev, curr) =>
                        prev is NotificationHistoryLoaded &&
                        curr is NotificationHistoryLoaded &&
                        prev.unreadCount != curr.unreadCount,
                    builder: (context, state) {
                      if (state is NotificationHistoryLoaded &&
                          state.unreadCount > 0) {
                        return Text(
                          '${state.unreadCount} unread',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // Mark all as read button.
            BlocBuilder<NotificationHistoryBloc, NotificationHistoryState>(
              buildWhen: (prev, curr) =>
                  prev is NotificationHistoryLoaded &&
                  curr is NotificationHistoryLoaded &&
                  prev.unreadCount != curr.unreadCount,
              builder: (context, state) {
                if (state is NotificationHistoryLoaded &&
                    state.unreadCount > 0) {
                  return HeaderActionButton(
                    icon: Icons.done_all_rounded,
                    tooltip: 'Mark all as read',
                    onTap: () {
                      final docId = _doctorId(context);
                      if (docId == null) return;
                      context.read<NotificationHistoryBloc>().add(
                            MarkAllNotificationsRead(doctorId: docId),
                          );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(width: 8),
            // Clear all button.
            BlocBuilder<NotificationHistoryBloc, NotificationHistoryState>(
              buildWhen: (prev, curr) {
                final prevLen = prev is NotificationHistoryLoaded
                    ? prev.notifications.length
                    : -1;
                final currLen = curr is NotificationHistoryLoaded
                    ? curr.notifications.length
                    : -1;
                return prevLen != currLen;
              },
              builder: (context, state) {
                if (state is NotificationHistoryLoaded &&
                    state.notifications.isNotEmpty) {
                  return HeaderActionButton(
                    icon: Icons.delete_sweep_rounded,
                    tooltip: 'Clear all',
                    onTap: () => showClearAllDialog(
                      context,
                      doctorId: _doctorId(context),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}