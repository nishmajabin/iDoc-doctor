import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/screens/legal_document_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/widgets/legal_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const _sections = [
    LegalSection(
      heading: '1. Information We Collect',
      body:
          'We collect personal information you provide when registering, including your name, email address, phone number, medical license number, and profile image. We also collect usage data to improve our services.',
    ),
    LegalSection(
      heading: '2. How We Use Your Information',
      body:
          'Your information is used to manage your doctor profile, facilitate patient consultations, process payments, and send relevant notifications. We do not sell your personal data to third parties.',
    ),
    LegalSection(
      heading: '3. Data Security',
      body:
          'We implement industry-standard encryption and security measures to protect your data. All communications between our app and servers are encrypted using TLS. Firebase Authentication secures your login credentials.',
    ),
    LegalSection(
      heading: '4. Data Sharing',
      body:
          'Patient data is only shared between the respective doctor and patient involved in a consultation. Aggregated, anonymized data may be used for improving platform services. We never share identifiable data without explicit consent.',
    ),
    LegalSection(
      heading: '5. Cookies & Tracking',
      body:
          'Our mobile application does not use traditional cookies. We use Firebase Analytics to collect anonymized usage statistics to improve app performance and user experience.',
    ),
    LegalSection(
      heading: '6. Your Rights',
      body:
          'You have the right to access, correct, or request deletion of your personal data at any time. You may contact our support team to exercise these rights. Account deletion will remove all associated data within 30 days.',
    ),
    LegalSection(
      heading: '7. Contact Us',
      body:
          'For any privacy-related concerns, please contact our Data Protection Officer at privacy@idoc.health or write to us at our registered office address.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LegalDocumentScreen(
      title: 'Privacy Policy',
      lastUpdated: 'April 5, 2026',
      sections: _sections,
    );
  }
}
