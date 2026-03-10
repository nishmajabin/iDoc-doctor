import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/notification_item_model.dart';
import 'package:idoc_doctor_side/logic/blocs/notification/notification_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification/notification_state.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_event.dart';
import 'package:idoc_doctor_side/logic/blocs/notification_history/notification_history_state.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final notifState = context.read<NotificationBloc>().state;
    if (notifState is NotificationReady) {
      context.read<NotificationHistoryBloc>().add(
            LoadNotificationHistory(doctorId: notifState.doctorId),
          );
    }
  }

  String? get _doctorId {
    final state = context.read<NotificationBloc>().state;
    if (state is NotificationReady) return state.doctorId;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.gradientStart,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.bgBase,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: _buildBody(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
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
                  BlocBuilder<NotificationHistoryBloc,
                      NotificationHistoryState>(
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
              builder: (context, state) {
                if (state is NotificationHistoryLoaded &&
                    state.unreadCount > 0) {
                  return _HeaderAction(
                    icon: Icons.done_all_rounded,
                    tooltip: 'Mark all as read',
                    onTap: () {
                      final docId = _doctorId;
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
              builder: (context, state) {
                if (state is NotificationHistoryLoaded &&
                    state.notifications.isNotEmpty) {
                  return _HeaderAction(
                    icon: Icons.delete_sweep_rounded,
                    tooltip: 'Clear all',
                    onTap: () => _showClearAllDialog(context),
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

  // ── BODY ──────────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<NotificationHistoryBloc, NotificationHistoryState>(
      builder: (context, state) {
        if (state is NotificationHistoryLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is NotificationHistoryError) {
          return _EmptyOrError(
            icon: Icons.error_outline_rounded,
            title: 'Something went wrong',
            subtitle: state.message,
          );
        }

        if (state is NotificationHistoryLoaded) {
          if (state.notifications.isEmpty) {
            return const _EmptyOrError(
              icon: Icons.notifications_off_rounded,
              title: 'No notifications yet',
              subtitle: 'You\'ll see appointment bookings,\nchat messages, and reminders here.',
            );
          }

          return _NotificationList(
            notifications: state.notifications,
            doctorId: _doctorId ?? '',
          );
        }

        // Initial / not loaded state.
        return const _EmptyOrError(
          icon: Icons.notifications_off_rounded,
          title: 'No notifications yet',
          subtitle: 'You\'ll see appointment bookings,\nchat messages, and reminders here.',
        );
      },
    );
  }

  // ── DIALOGS ───────────────────────────────────────────────────────────────

  void _showClearAllDialog(BuildContext context) {
    final docId = _doctorId;
    if (docId == null) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Notifications'),
        content: const Text(
            'Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotificationHistoryBloc>().add(
                    ClearAllNotifications(doctorId: docId),
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
}

// ═══════════════════════════════════════════════════════════════════════════════
//  WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

// ── Notification List ───────────────────────────────────────────────────────

class _NotificationList extends StatelessWidget {
  final List<NotificationItemModel> notifications;
  final String doctorId;

  const _NotificationList({
    required this.notifications,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    // Group by date.
    final grouped = <String, List<NotificationItemModel>>{};
    for (final n in notifications) {
      final dateKey = _dateLabel(n.timestamp);
      grouped.putIfAbsent(dateKey, () => []).add(n);
    }

    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, sectionIndex) {
        final dateLabel = keys[sectionIndex];
        final items = grouped[dateLabel]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
              child: Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            ...items.map(
              (n) => _NotificationCard(
                notification: n,
                doctorId: doctorId,
              ),
            ),
          ],
        );
      },
    );
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(dt);
  }
}

// ── Notification Card ───────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationItemModel notification;
  final String doctorId;

  const _NotificationCard({
    required this.notification,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    final typeData = _typeVisuals(notification.type);

    return Dismissible(
      key: Key(notification.notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.cancelled.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppColors.cancelled, size: 26),
      ),
      onDismissed: (_) {
        context.read<NotificationHistoryBloc>().add(
              DeleteNotification(
                doctorId: doctorId,
                notificationId: notification.notificationId,
              ),
            );
      },
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : AppColors.primarySurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.divider
                  : AppColors.primary.withValues(alpha: 0.18),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Icon ────────────────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeData.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  typeData.icon,
                  color: typeData.color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),

              // ── Content ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.body,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: typeData.color.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            typeData.label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: typeData.color,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(notification.timestamp),
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    // Mark as read.
    if (!notification.isRead) {
      context.read<NotificationHistoryBloc>().add(
            MarkNotificationRead(
              doctorId: doctorId,
              notificationId: notification.notificationId,
            ),
          );
    }

    // Navigate based on type.
    final data = notification.data;
    if (data == null) return;

    switch (notification.type) {
      case NotificationType.appointmentBooked:
      case NotificationType.appointmentReminder:
        // Navigate to appointment screen tab (index 3 on BottomNav).
        // For deeper navigation, the user can integrate their appointment
        // detail screen here using data['appointmentId'].
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening appointment details…'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      case NotificationType.chatMessage:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening chat…'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        break;
      case NotificationType.general:
        break;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('h:mm a').format(dt);
  }

  _TypeVisual _typeVisuals(NotificationType type) {
    switch (type) {
      case NotificationType.appointmentBooked:
        return _TypeVisual(
          icon: Icons.calendar_today_rounded,
          color: AppColors.confirmed,
          label: 'Appointment',
        );
      case NotificationType.chatMessage:
        return _TypeVisual(
          icon: Icons.chat_bubble_rounded,
          color: AppColors.accent,
          label: 'Chat',
        );
      case NotificationType.appointmentReminder:
        return _TypeVisual(
          icon: Icons.alarm_rounded,
          color: AppColors.pending,
          label: 'Reminder',
        );
      case NotificationType.general:
        return _TypeVisual(
          icon: Icons.info_outline_rounded,
          color: AppColors.textSecondary,
          label: 'General',
        );
    }
  }
}

class _TypeVisual {
  final IconData icon;
  final Color color;
  final String label;

  const _TypeVisual({
    required this.icon,
    required this.color,
    required this.label,
  });
}

// ── Empty / Error State ─────────────────────────────────────────────────────

class _EmptyOrError extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyOrError({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: AppColors.primary.withValues(alpha: 0.35),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}