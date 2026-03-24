import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Help & Support ────────────────────────────────────────────────────────────
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _GradientAppBar(title: 'Help & Support'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContactBanner(),
            const SizedBox(height: 28),
            _SectionLabel(label: 'Quick Actions'),
            const SizedBox(height: 12),
            _ContactCard(
              children: [
                _ContactTile(
                  icon: Icons.email_outlined,
                  iconColor: AppColors.primary,
                  bgColor: AppColors.primarySurface,
                  title: 'Email Support',
                  subtitle: 'support@idoc.health',
                  trailing: const Icon(Icons.open_in_new_rounded,
                      size: 16, color: AppColors.textSecondary),
                  onTap: () => _launchUrl('mailto:support@idoc.health'),
                  isFirst: true,
                ),
                _Divider(),
                _ContactTile(
                  icon: Icons.phone_outlined,
                  iconColor: AppColors.confirmed,
                  bgColor: AppColors.confirmedSurface,
                  title: 'Call Us',
                  subtitle: '+91 1800 123 4567 (Toll-free)',
                  trailing: const Icon(Icons.call_outlined,
                      size: 16, color: AppColors.textSecondary),
                  onTap: () => _launchUrl('tel:+911800123456'),
                ),
                _Divider(),
                _ContactTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: AppColors.completed,
                  bgColor: AppColors.completedSurface,
                  title: 'Live Chat',
                  subtitle: 'Available 9 AM – 6 PM IST',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.completedSurface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Online',
                        style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: AppColors.completed,
                            fontWeight: FontWeight.w600)),
                  ),
                  onTap: () {},
                  isLast: true,
                ),
              ],
            ),
            const SizedBox(height: 28),
            _SectionLabel(label: 'FAQs'),
            const SizedBox(height: 12),
            ..._faqs.map((faq) => _FaqItem(faq: faq)),
          ],
        ),
      ),
    );
  }

  static const _faqs = [
    _Faq(
      question: 'How do I update my consultation fee?',
      answer:
          'Go to Edit Profile → Consultation Details. Update your fee and save. Changes take effect immediately for new bookings.',
    ),
    _Faq(
      question: 'How are payments processed?',
      answer:
          'Payments are collected from patients upfront via our secure gateway. Your earnings are settled to your registered bank account every 7 working days.',
    ),
    _Faq(
      question: 'Can I reschedule a confirmed appointment?',
      answer:
          'You can reschedule appointments up to 2 hours before the scheduled time. Go to the appointment detail and tap "Reschedule".',
    ),
    _Faq(
      question: "What happens if a patient doesn't show up?",
      answer:
          "If a patient misses a consultation, you can mark it as a no-show. The platform's no-show policy ensures you receive a partial consultation fee.",
    ),
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

class _Faq {
  final String question;
  final String answer;
  const _Faq({required this.question, required this.answer});
}

class _FaqItem extends StatefulWidget {
  final _Faq faq;
  const _FaqItem({required this.faq});
  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expanded
                ? AppColors.primary.withOpacity(0.25)
                : AppColors.divider,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(_expanded ? 0.07 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.faq.question,
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  if (_expanded) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.divider),
                    const SizedBox(height: 10),
                    Text(widget.faq.answer,
                        style: GoogleFonts.poppins(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            height: 1.7)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('We\'re here to help',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text('Our support team is ready\nto assist you anytime.',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final List<Widget> children;
  const _ContactCard({required this.children});
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

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;
  const _ContactTile({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: bgColor, borderRadius: BorderRadius.circular(11)),
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
                    Text(subtitle,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const Divider(
      height: 1, indent: 70, endIndent: 16, color: AppColors.divider);
}

// ─── About App ────────────────────────────────────────────────────────────────
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _GradientAppBar(title: 'About App'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          children: [
            _AppLogoSection(),
            const SizedBox(height: 28),
            _AboutInfoCard(),
            const SizedBox(height: 28),
            _TeamCard(),
          ],
        ),
      ),
    );
  }
}

class _AppLogoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: const Icon(Icons.medical_services_outlined,
                color: Colors.white, size: 36),
          ),
          const SizedBox(height: 16),
          Text('iDoc',
              style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5)),
          Text('Doctor Side',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withOpacity(0.25), width: 1),
            ),
            child: Text('Version 1.0.0',
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _AboutInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RowWithBar(label: 'About iDoc'),
          const SizedBox(height: 12),
          Text(
            'iDoc is a modern telemedicine platform that connects licensed doctors with patients across India. Our mission is to make quality healthcare accessible to everyone, anytime, anywhere.',
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.75),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 16),
          _AboutStatRow(),
        ],
      ),
    );
  }
}

class _AboutStatRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _AboutStat(value: '10K+', label: 'Doctors'),
        _AboutStat(value: '500K+', label: 'Patients'),
        _AboutStat(value: '4.8 ★', label: 'Rating'),
      ],
    );
  }
}

class _AboutStat extends StatelessWidget {
  final String value;
  final String label;
  const _AboutStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: -0.5)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RowWithBar(label: 'App Info'),
          const SizedBox(height: 16),
          _InfoLine(label: 'Developer', value: 'iDoc Technologies Pvt. Ltd.'),
          const SizedBox(height: 10),
          _InfoLine(label: 'Build', value: '1.0.0+1'),
          const SizedBox(height: 10),
          _InfoLine(label: 'Platform', value: 'Flutter • Firebase'),
          const SizedBox(height: 10),
          _InfoLine(label: 'Contact', value: 'hello@idoc.health'),
          const SizedBox(height: 10),
          _InfoLine(label: 'Website', value: 'www.idoc.health'),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;
  const _InfoLine({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: AppColors.textSecondary)),
        const Spacer(),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _RowWithBar extends StatelessWidget {
  final String label;
  const _RowWithBar({required this.label});
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
                color: AppColors.textPrimary)),
      ],
    );
  }
}

// ─── Reusable gradient AppBar ─────────────────────────────────────────────────
class _GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const _GradientAppBar({required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.gradientStart,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(title,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
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