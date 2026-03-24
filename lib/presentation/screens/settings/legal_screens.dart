import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/constants/color.dart';

// ─── Shared legal document screen ─────────────────────────────────────────────
class _LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final List<_LegalSection> sections;

  const _LegalDocumentScreen({
    required this.title,
    required this.lastUpdated,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
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
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.3)),
                        const SizedBox(height: 4),
                        Text('Last updated: $lastUpdated',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.white.withOpacity(0.7))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
              child: Column(
                children: sections
                    .map((section) => _LegalSectionCard(section: section))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegalSection {
  final String heading;
  final String body;
  const _LegalSection({required this.heading, required this.body});
}

class _LegalSectionCard extends StatelessWidget {
  final _LegalSection section;
  const _LegalSectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4, height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(section.heading,
                      style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(section.body,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.75)),
          ],
        ),
      ),
    );
  }
}

// ─── Privacy Policy ────────────────────────────────────────────────────────────
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    _LegalSection(
      heading: '1. Information We Collect',
      body:
          'We collect personal information you provide when registering, including your name, email address, phone number, medical license number, and profile image. We also collect usage data to improve our services.',
    ),
    _LegalSection(
      heading: '2. How We Use Your Information',
      body:
          'Your information is used to manage your doctor profile, facilitate patient consultations, process payments, and send relevant notifications. We do not sell your personal data to third parties.',
    ),
    _LegalSection(
      heading: '3. Data Security',
      body:
          'We implement industry-standard encryption and security measures to protect your data. All communications between our app and servers are encrypted using TLS. Firebase Authentication secures your login credentials.',
    ),
    _LegalSection(
      heading: '4. Data Sharing',
      body:
          'Patient data is only shared between the respective doctor and patient involved in a consultation. Aggregated, anonymized data may be used for improving platform services. We never share identifiable data without explicit consent.',
    ),
    _LegalSection(
      heading: '5. Cookies & Tracking',
      body:
          'Our mobile application does not use traditional cookies. We use Firebase Analytics to collect anonymized usage statistics to improve app performance and user experience.',
    ),
    _LegalSection(
      heading: '6. Your Rights',
      body:
          'You have the right to access, correct, or request deletion of your personal data at any time. You may contact our support team to exercise these rights. Account deletion will remove all associated data within 30 days.',
    ),
    _LegalSection(
      heading: '7. Contact Us',
      body:
          'For any privacy-related concerns, please contact our Data Protection Officer at privacy@idoc.health or write to us at our registered office address.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _LegalDocumentScreen(
      title: 'Privacy Policy',
      lastUpdated: 'January 1, 2025',
      sections: _sections,
    );
  }
}

// ─── Terms & Conditions ───────────────────────────────────────────────────────
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  static const _sections = [
    _LegalSection(
      heading: '1. Acceptance of Terms',
      body:
          'By creating an account and using the iDoc Doctor platform, you agree to be bound by these Terms & Conditions. If you do not agree, you must discontinue use of the platform immediately.',
    ),
    _LegalSection(
      heading: '2. Professional Eligibility',
      body:
          'This platform is exclusively for licensed medical professionals. You must hold a valid, active medical license to register. Submitting false credentials is grounds for immediate account termination and may be reported to relevant authorities.',
    ),
    _LegalSection(
      heading: '3. Code of Conduct',
      body:
          'You agree to maintain professional conduct in all patient interactions, provide accurate medical information, keep patient data confidential, and comply with all applicable medical regulations and standards of care.',
    ),
    _LegalSection(
      heading: '4. Platform Use',
      body:
          'The platform must not be used for unlawful purposes. You are responsible for maintaining the confidentiality of your account credentials. Sharing your account with others is strictly prohibited.',
    ),
    _LegalSection(
      heading: '5. Fees & Payments',
      body:
          'Consultation fees are set by you within platform guidelines. iDoc retains a service fee as outlined in the fee schedule. Payments are processed securely through our payment gateway partners.',
    ),
    _LegalSection(
      heading: '6. Intellectual Property',
      body:
          'All platform content, trademarks, and software are owned by iDoc. You retain ownership of your professional profile content but grant iDoc a license to display it on the platform.',
    ),
    _LegalSection(
      heading: '7. Termination',
      body:
          'iDoc reserves the right to suspend or terminate accounts that violate these terms, receive significant patient complaints, or engage in fraudulent activity, with or without prior notice.',
    ),
    _LegalSection(
      heading: '8. Limitation of Liability',
      body:
          'iDoc is a platform facilitating connections between doctors and patients. We are not liable for the quality of medical advice provided. Doctors bear full professional responsibility for their consultations.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _LegalDocumentScreen(
      title: 'Terms & Conditions',
      lastUpdated: 'January 1, 2025',
      sections: _sections,
    );
  }
}