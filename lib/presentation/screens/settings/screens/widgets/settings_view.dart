import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/core/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/screens/privacy_policy_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/screens/terms_and_conditions_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/notification_setting/screens/notifcation_settings_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/app_version_tag.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/setting_logout_button.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_appbar.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_doctor_card.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_group.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_item.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/widgets/settings_section_label.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/screens/about_app_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/screens/help_support_screen.dart';

class SettingsView extends StatelessWidget {
  final DoctorModel doctor;
  const SettingsView({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsLogoutSuccess) {
          // Navigate to login screen – replace with your actual login route
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (_) => false);
        } else if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.cancelled,
          ));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SettingsAppBar(doctor: doctor),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Doctor profile card ──────────────────────────────────
                    SettingsDoctorCard(doctor: doctor),
                    const SizedBox(height: 28),

                    // ── Account ──────────────────────────────────────────────
                    SettingsSectionLabel(label: 'Account'),
                    const SizedBox(height: 12),
                    SettingsGroup(
                      items: [
                        SettingsItem(
                          icon: Icons.person_outline_rounded,
                          iconColor: AppColors.primary,
                          bgColor: AppColors.primarySurface,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () => _push(
                              context,
                              EditProfileScreen(currentDoctor: doctor)),
                          isFirst: true,
                        ),
                        SettingsItem(
                          icon: Icons.notifications_none_rounded,
                          iconColor: AppColors.confirmed,
                          bgColor: AppColors.confirmedSurface,
                          title: 'Notification Settings',
                          subtitle: 'Manage alerts and reminders',
                          onTap: () => _push(
                              context,
                              BlocProvider.value(
                                value: context.read<SettingsBloc>(),
                                child:
                                    const NotificationSettingsScreen(),
                              )),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Legal ─────────────────────────────────────────────────
                    SettingsSectionLabel(label: 'Legal'),
                    const SizedBox(height: 12),
                    SettingsGroup(
                      items: [
                        SettingsItem(
                          icon: Icons.shield_outlined,
                          iconColor: AppColors.completed,
                          bgColor: AppColors.completedSurface,
                          title: 'Privacy Policy',
                          subtitle: 'How we handle your data',
                          onTap: () => _push(context,
                              const PrivacyPolicyScreen()),
                          isFirst: true,
                        ),
                        SettingsItem(
                          icon: Icons.article_outlined,
                          iconColor: AppColors.pending,
                          bgColor: AppColors.pendingSurface,
                          title: 'Terms & Conditions',
                          subtitle: 'Platform usage agreement',
                          onTap: () => _push(context,
                              const TermsAndConditionsScreen()),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Support ───────────────────────────────────────────────
                    SettingsSectionLabel(label: 'Support'),
                    const SizedBox(height: 12),
                    SettingsGroup(
                      items: [
                        SettingsItem(
                          icon: Icons.help_outline_rounded,
                          iconColor: AppColors.accent,
                          bgColor: AppColors.primarySurface,
                          title: 'Help & Support',
                          subtitle: 'FAQs and contact options',
                          onTap: () => _push(context,
                              const HelpSupportScreen()),
                          isFirst: true,
                        ),
                        SettingsItem(
                          icon: Icons.info_outline_rounded,
                          iconColor: AppColors.textSecondary,
                          bgColor: const Color(0xFFF0F3F7),
                          title: 'About App',
                          subtitle: 'Version, credits and more',
                          onTap: () =>
                              _push(context, const AboutAppScreen()),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Logout ────────────────────────────────────────────────
                    SettingLogoutButton(),
                    const SizedBox(height: 20),
                    AppVersionTag(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => screen));
  }
}