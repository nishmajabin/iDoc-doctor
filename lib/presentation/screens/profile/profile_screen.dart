import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:idoc_doctor_side/data/models/doctor_model.dart';
import 'package:idoc_doctor_side/data/models/doctor_profile_stats_model.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_bloc.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_event.dart';
import 'package:idoc_doctor_side/logic/blocs/profile/profile_state.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/settings_screen.dart';
import 'package:intl/intl.dart';

// ─── Entry point ──────────────────────────────────────────────────────────────
class DoctorProfileScreen extends StatelessWidget {
  final DoctorModel currentDoctor;
  const DoctorProfileScreen({required this.currentDoctor, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorProfileBloc()
        ..add(LoadDoctorProfile(currentDoctor.id!)),
      child: const _ProfileView(),
    );
  }
}

// ─── View ─────────────────────────────────────────────────────────────────────
class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: BlocBuilder<DoctorProfileBloc, DoctorProfileState>(
        builder: (context, state) {
          if (state is DoctorProfileInitial || state is DoctorProfileLoading) {
            return const _Loader();
          }
          if (state is DoctorProfileError) {
            return _ErrorView(message: state.message);
          }
          if (state is DoctorProfileLoaded) {
            return _ProfileContent(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// ─── Loader ───────────────────────────────────────────────────────────────────
class _Loader extends StatelessWidget {
  const _Loader();
  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
}

// ─── Error ────────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: AppColors.cancelled),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    color: AppColors.textSecondary, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ─── Profile content ──────────────────────────────────────────────────────────
class _ProfileContent extends StatelessWidget {
  final DoctorProfileLoaded state;
  const _ProfileContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final doctor = state.doctor;
    final stats  = state.stats;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.gradientStart,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            // ── Refresh stats ──────────────────────────────────────────────
            state.isStatsRefreshing
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.white, size: 22),
                    onPressed: () => context
                        .read<DoctorProfileBloc>()
                        .add(RefreshProfileStats(doctorId: doctor.id!)),
                  ),
            // ── Settings ───────────────────────────────────────────────────
            IconButton(
              icon: const Icon(Icons.settings_outlined,
                  color: Colors.white, size: 22),
              tooltip: 'Settings',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      DoctorSettingsScreen(currentDoctor: doctor),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
            ],
            background: _Header(doctor: doctor),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionLabel(label: 'Revenue Overview'),
                const SizedBox(height: 12),
                _RevenueDashboard(
                    stats: stats, isLoading: state.isStatsRefreshing),
                const SizedBox(height: 28),
                _SectionLabel(label: 'About'),
                const SizedBox(height: 12),
                _AboutCard(bio: doctor.bio),
                const SizedBox(height: 28),
                _SectionLabel(label: 'Information'),
                const SizedBox(height: 12),
                _InfoCard(doctor: doctor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final DoctorModel doctor;
  const _Header({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        Positioned(
            top: -40, right: -40, child: _Circle(size: 200, opacity: 0.10)),
        Positioned(
            bottom: 20, left: -30, child: _Circle(size: 140, opacity: 0.07)),
        Positioned(
          bottom: 24, left: 0, right: 0,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.accent.withOpacity(0.3),
                  backgroundImage: doctor.profileImageUrl != null
                      ? NetworkImage(doctor.profileImageUrl!)
                      : null,
                  child: doctor.profileImageUrl == null
                      ? Text(_initials(doctor.name),
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white))
                      : null,
                ),
              ),
              const SizedBox(height: 12),
              Text('Dr. ${doctor.name}',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.3), width: 1),
                ),
                child: Text(doctor.specialist,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
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

// ─── Revenue dashboard ────────────────────────────────────────────────────────
class _RevenueDashboard extends StatelessWidget {
  final DoctorProfileStats stats;
  final bool isLoading;
  const _RevenueDashboard({required this.stats, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TotalRevenueBanner(stats: stats, isLoading: isLoading),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle_outline_rounded,
                iconColor: AppColors.confirmed,
                bgColor: AppColors.confirmedSurface,
                label: 'Consultations',
                value: stats.totalPaidAppointments.toString(),
                sub: '${stats.thisMonthAppointments} this month',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.people_outline_rounded,
                iconColor: AppColors.primary,
                bgColor: AppColors.primarySurface,
                label: 'Patients',
                value: stats.totalPatients.toString(),
                sub: 'Unique',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.pending_actions_outlined,
                iconColor: AppColors.pending,
                bgColor: AppColors.pendingSurface,
                label: 'Pending',
                value: stats.pendingAppointments.toString(),
                sub: 'Awaiting',
              ),
            ),
          ],
        ),
        if (!isLoading && stats.totalPaidAppointments > 0) ...[
          const SizedBox(height: 12),
          _BreakdownCard(stats: stats),
        ],
      ],
    );
  }
}

class _TotalRevenueBanner extends StatelessWidget {
  final DoctorProfileStats stats;
  final bool isLoading;
  const _TotalRevenueBanner({required this.stats, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientStart.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.account_balance_wallet_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text('Total Earnings',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              if (isLoading)
                const SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.25), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryLight),
                      ),
                      const SizedBox(width: 5),
                      Text('Live',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            fmt.format(stats.totalRevenue),
            style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1.5),
          ),
          const SizedBox(height: 6),
          Container(
              height: 1,
              color: Colors.white.withOpacity(0.18),
              margin: const EdgeInsets.only(bottom: 10)),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded,
                  size: 16, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text('This month: ${fmt.format(stats.thisMonthRevenue)}',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                '${stats.thisMonthAppointments} session${stats.thisMonthAppointments == 1 ? '' : 's'}',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.7)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  final DoctorProfileStats stats;
  const _BreakdownCard({required this.stats});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _BreakdownItem(
                color: AppColors.completed,
                bgColor: AppColors.completedSurface,
                label: 'Completed',
                value: stats.totalCompletedAppointments,
                tooltip: 'Consultation done'),
          ),
          Container(width: 1, height: 36, color: AppColors.divider),
          Expanded(
            child: _BreakdownItem(
                color: AppColors.confirmed,
                bgColor: AppColors.confirmedSurface,
                label: 'Confirmed',
                value: stats.totalConfirmedAppointments,
                tooltip: 'Paid, awaiting consultation'),
          ),
        ],
      ),
    );
  }
}

class _BreakdownItem extends StatelessWidget {
  final Color color;
  final Color bgColor;
  final String label;
  final int value;
  final String tooltip;
  const _BreakdownItem({
    required this.color,
    required this.bgColor,
    required this.label,
    required this.value,
    required this.tooltip,
  });
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 8, height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value.toString(),
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color)),
        ],
      ),
    );
  }
}

// ─── Stat card ────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String value;
  final String sub;
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.value,
    required this.sub,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5)),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 2),
          Text(sub,
              style: GoogleFonts.poppins(
                  fontSize: 9, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ─── About card ───────────────────────────────────────────────────────────────
class _AboutCard extends StatefulWidget {
  final String bio;
  const _AboutCard({required this.bio});
  @override
  State<_AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<_AboutCard> {
  bool _expanded = false;
  static const int _preview = 160;
  @override
  Widget build(BuildContext context) {
    final isLong = widget.bio.length > _preview;
    final text = _expanded || !isLong
        ? widget.bio
        : '${widget.bio.substring(0, _preview)}...';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.7)),
          if (isLong) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Show less' : 'Read more',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Info card ────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final DoctorModel doctor;
  const _InfoCard({required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
              icon: Icons.email_outlined,
              iconColor: AppColors.primary,
              bgColor: AppColors.primarySurface,
              label: 'Email',
              value: doctor.email,
              isFirst: true),
          _Divider(),
          _InfoRow(
              icon: Icons.phone_outlined,
              iconColor: AppColors.confirmed,
              bgColor: AppColors.confirmedSurface,
              label: 'Phone',
              value: doctor.phone),
          _Divider(),
          _InfoRow(
              icon: Icons.location_on_outlined,
              iconColor: AppColors.pending,
              bgColor: AppColors.pendingSurface,
              label: 'Location',
              value: doctor.place),
          _Divider(),
          _InfoRow(
              icon: Icons.badge_outlined,
              iconColor: AppColors.completed,
              bgColor: AppColors.completedSurface,
              label: 'License No.',
              value: doctor.licenseNumber),
          _Divider(),
          _InfoRow(
              icon: Icons.workspace_premium_outlined,
              iconColor: AppColors.accent,
              bgColor: AppColors.primarySurface,
              label: 'Experience',
              value: '${doctor.experience} years'),
          _Divider(),
          _InfoRow(
              icon: Icons.wc_outlined,
              iconColor: AppColors.textSecondary,
              bgColor: const Color(0xFFF0F3F7),
              label: 'Gender',
              value: doctor.gender,
              isLast: true),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String value;
  final bool isFirst;
  final bool isLast;
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.value,
    this.isFirst = false,
    this.isLast = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, isFirst ? 16 : 12, 16, isLast ? 16 : 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 10.5,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 1),
                Text(value,
                    style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
      height: 1, indent: 66, endIndent: 16, color: AppColors.divider);
}