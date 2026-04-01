import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/faq.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/faq_item.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_gradient_appbar.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_about_section_label.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_contact_banner.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_contact_card.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_contact_tile.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/support/widgets/help_divider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: HelpAboutGradientAppbar(title: 'Help & Support'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HelpContactBanner(),
            const SizedBox(height: 28),
            HelpAboutSectionLabel(label: 'Quick Actions'),
            const SizedBox(height: 12),
            HelpContactCard(
              children: [
                HelpContactTile(
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
                HelpDivider(),
                HelpContactTile(
                  icon: Icons.phone_outlined,
                  iconColor: AppColors.confirmed,
                  bgColor: AppColors.confirmedSurface,
                  title: 'Call Us',
                  subtitle: '+91 1800 123 4567 (Toll-free)',
                  trailing: const Icon(Icons.call_outlined,
                      size: 16, color: AppColors.textSecondary),
                  onTap: () => _launchUrl('tel:+911800123456'),
                ),
                
              ],
            ),
            const SizedBox(height: 28),
            HelpAboutSectionLabel(label: 'FAQs'),
            const SizedBox(height: 12),
            ..._faqs.map((faq) => FaqItem(faq: faq)),
          ],
        ),
      ),
    );
  }

  static const _faqs = [
    Faq(
      question: 'How do I update my consultation fee?',
      answer:
          'Go to Edit Profile → Consultation Details. Update your fee and save. Changes take effect immediately for new bookings.',
    ),
    Faq(
      question: 'How are payments processed?',
      answer:
          'Payments are collected from patients upfront via our secure gateway. Your earnings are settled to your registered bank account every 7 working days.',
    ),
    Faq(
      question: 'Can I reschedule a confirmed appointment?',
      answer:
          'You can reschedule appointments up to 2 hours before the scheduled time. Go to the appointment detail and tap "Reschedule".',
    ),
    Faq(
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