import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/notification_item_model.dart';
import 'package:intl/intl.dart';
import 'notification_card.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationItemModel> notifications;
  final String doctorId;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.doctorId,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDate(notifications);
    final keys = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final dateLabel = keys[index];
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
              (n) => NotificationCard(notification: n, doctorId: doctorId),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<NotificationItemModel>> _groupByDate(
    List<NotificationItemModel> items,
  ) {
    final grouped = <String, List<NotificationItemModel>>{};
    for (final n in items) {
      grouped.putIfAbsent(_dateLabel(n.timestamp), () => []).add(n);
    }
    return grouped;
  }

  String _dateLabel(DateTime dt) {
    final today = DateUtils.dateOnly(DateTime.now());
    final date = DateUtils.dateOnly(dt);

    if (date == today) return 'Today';
    if (date == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('d MMM yyyy').format(dt);
  }
}