import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_event.dart';
import 'package:idoc_doctor_side/logic/blocs/settings/settings_state.dart';
import 'package:idoc_doctor_side/presentation/screens/profile/edit_profile_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/help_about_screens.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/legal_screens.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/notifcation_settings_screen.dart';

// ─── Entry point ───────────────────────────────────────────────────────────────
class DoctorSettingsScreen extends StatelessWidget {
  final DoctorModel currentDoctor;
  const DoctorSettingsScreen({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc()..add(const LoadSettings()),
      child: _SettingsView(doctor: currentDoctor),
    );
  }
}

// ─── Main view ────────────────────────────────────────────────────────────────
class _SettingsView extends StatelessWidget {
  final DoctorModel doctor;
  const _SettingsView({required this.doctor});

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
            _SettingsAppBar(doctor: doctor),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Doctor profile card ──────────────────────────────────
                    _DoctorCard(doctor: doctor),
                    const SizedBox(height: 28),

                    // ── Account ──────────────────────────────────────────────
                    _SectionLabel(label: 'Account'),
                    const SizedBox(height: 12),
                    _SettingsGroup(
                      items: [
                        _SettingsItem(
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
                        _SettingsItem(
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
                    _SectionLabel(label: 'Legal'),
                    const SizedBox(height: 12),
                    _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.shield_outlined,
                          iconColor: AppColors.completed,
                          bgColor: AppColors.completedSurface,
                          title: 'Privacy Policy',
                          subtitle: 'How we handle your data',
                          onTap: () => _push(context,
                              const PrivacyPolicyScreen()),
                          isFirst: true,
                        ),
                        _SettingsItem(
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
                    _SectionLabel(label: 'Support'),
                    const SizedBox(height: 12),
                    _SettingsGroup(
                      items: [
                        _SettingsItem(
                          icon: Icons.help_outline_rounded,
                          iconColor: AppColors.accent,
                          bgColor: AppColors.primarySurface,
                          title: 'Help & Support',
                          subtitle: 'FAQs and contact options',
                          onTap: () => _push(context,
                              const HelpSupportScreen()),
                          isFirst: true,
                        ),
                        _SettingsItem(
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
                    _LogoutButton(),
                    const SizedBox(height: 20),
                    _AppVersionTag(),
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

// ─── SliverAppBar ─────────────────────────────────────────────────────────────
class _SettingsAppBar extends StatelessWidget {
  final DoctorModel doctor;
  const _SettingsAppBar({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Decorative circles
            Positioned(
                top: -30, right: -30,
                child: _Circle(size: 160, opacity: 0.08)),
            Positioned(
                bottom: 10, left: -20,
                child: _Circle(size: 100, opacity: 0.06)),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings',
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5)),
                    Text('Manage your account & preferences',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});
  @override
  Widget build(BuildContext context) => Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      );
}

// ─── Doctor card ───────────────────────────────────────────────────────────────
class _DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppColors.primarySurface, width: 3),
            ),
            child: CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primarySurface,
              backgroundImage: doctor.profileImageUrl != null
                  ? NetworkImage(doctor.profileImageUrl!)
                  : null,
              child: doctor.profileImageUrl == null
                  ? Text(_initials(doctor.name),
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary))
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. ${doctor.name}',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(doctor.specialist,
                      style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(doctor.place,
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: doctor.status == 'approved'
                  ? AppColors.completedSurface
                  : AppColors.pendingSurface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: doctor.status == 'approved'
                        ? AppColors.completed
                        : AppColors.pending,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  doctor.status == 'approved' ? 'Active' : 'Pending',
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: doctor.status == 'approved'
                          ? AppColors.completed
                          : AppColors.pending),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ─── Section label ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 18,
          decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2)),
      ],
    );
  }
}

// ─── Settings group card ──────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.items});
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
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Column(
            children: [
              item,
              if (i < items.length - 1)
                const Divider(
                    height: 1,
                    indent: 70,
                    endIndent: 16,
                    color: AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}

// ─── Individual settings row ──────────────────────────────────────────────────
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(18) : Radius.zero,
          bottom: isLast ? const Radius.circular(18) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
          child: Row(
            children: [
              // Icon box
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              // Labels
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
              // Chevron
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Logout button ────────────────────────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final isLoading = state is SettingsLoading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () => _showLogoutDialog(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: AppColors.cancelled.withOpacity(0.25), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cancelled.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: AppColors.cancelledSurface,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              color: AppColors.cancelled,
                              strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_rounded,
                          color: AppColors.cancelled, size: 18),
                ),
                const SizedBox(width: 12),
                Text('Logout',
                    style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cancelled)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cancelledSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: AppColors.cancelled, size: 32),
            ),
            const SizedBox(height: 16),
            Text('Logout',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            Text(
              'Are you sure you want to logout\nfrom your doctor account?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.6),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(
                          color: AppColors.divider, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                      context
                          .read<SettingsBloc>()
                          .add(const LogoutRequested());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cancelled,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Logout',
                        style: GoogleFonts.poppins(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── App version tag ──────────────────────────────────────────────────────────
class _AppVersionTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'iDoc Doctor v1.0.0 · Made with ❤️ in India',
        style: GoogleFonts.poppins(
            fontSize: 11, color: AppColors.textMuted),
      ),
    );
  }
}