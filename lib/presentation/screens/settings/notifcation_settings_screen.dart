import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_event.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_state.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is! SettingsLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return _NotificationBody(state: state);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Notification Settings',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class _NotificationBody extends StatelessWidget {
  final SettingsLoaded state;
  const _NotificationBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            subtitle: 'Manage how you receive alerts',
          ),
          const SizedBox(height: 12),
          _NotificationCard(
            children: [
              _NotificationTile(
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
          _SectionHeader(
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
              child: _NotificationCard(
                children: [
                  _NotificationTile(
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
                  _Divider(),
                  _NotificationTile(
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
          _InfoBanner(),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text(subtitle,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final List<Widget> children;
  const _NotificationCard({required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isFirst;
  final bool isLast;
  const _NotificationTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isFirst = false,
    this.isLast = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
      height: 1, indent: 70, endIndent: 16, color: AppColors.divider);
}

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Notification preferences are stored locally. System-level permissions must be granted from your device settings.',
              style: GoogleFonts.poppins(
                  fontSize: 11.5,
                  color: AppColors.primary,
                  height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}