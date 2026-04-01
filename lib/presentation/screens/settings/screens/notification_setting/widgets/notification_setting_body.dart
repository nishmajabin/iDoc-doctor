import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_event.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_state.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/widgets/notification_info_banner.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/widgets/notification_setting_card.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/widgets/notification_setting_divider.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/widgets/notification_setting_section_header.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/widgets/notification_setting_tile.dart';

class NotificationSettingBody extends StatelessWidget {
  final SettingsLoaded state;
  const NotificationSettingBody({required this.state, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationSettingSectionHeader(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            subtitle: 'Manage how you receive alerts',
          ),
          const SizedBox(height: 12),
          NotificationSettingCard(
            children: [
              NotificationSettingTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.primary,
                bgColor: AppColors.primarySurface,
                title: 'All Notifications',
                subtitle: 'Master toggle for all alerts',
                value: state.notificationsEnabled,
                onChanged: (v) => context
                    .read<SettingsBloc>()
                    .add(NotificationsToggled(v)),
                isFirst: true,
                isLast: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
          NotificationSettingSectionHeader(
            icon: Icons.tune_outlined,
            title: 'Alert Types',
            subtitle: 'Customize individual notification types',
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: state.notificationsEnabled ? 1 : 0.45,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !state.notificationsEnabled,
              child: NotificationSettingCard(
                children: [
                  NotificationSettingTile(
                    icon: Icons.calendar_today_outlined,
                    iconColor: AppColors.confirmed,
                    bgColor: AppColors.confirmedSurface,
                    title: 'Appointment Reminders',
                    subtitle: 'Get notified before scheduled appointments',
                    value: state.appointmentReminders,
                    onChanged: (v) => context
                        .read<SettingsBloc>()
                        .add(AppointmentRemindersToggled(v)),
                    isFirst: true,
                  ),
                  NotificationSettingDivider(),
                  NotificationSettingTile(
                    icon: Icons.person_add_outlined,
                    iconColor: AppColors.completed,
                    bgColor: AppColors.completedSurface,
                    title: 'New Patient Alerts',
                    subtitle: 'When a new patient books a consultation',
                    value: state.newPatientAlerts,
                    onChanged: (v) => context
                        .read<SettingsBloc>()
                        .add(NewPatientAlertsToggled(v)),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          NotificationInfoBanner(),
        ],
      ),
    );
  }
}