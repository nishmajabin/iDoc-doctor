import 'package:flutter/material.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/screens/legal_document_screen.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/widgets/legal_section.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  static const _sections = [
    LegalSection(
      heading: '1. Acceptance of Terms',
      body:
          'By creating an account and using the iDoc Doctor platform, you agree to be bound by these Terms & Conditions. If you do not agree, you must discontinue use of the platform immediately.',
    ),
    LegalSection(
      heading: '2. Professional Eligibility',
      body:
          'This platform is exclusively for licensed medical professionals. You must hold a valid, active medical license to register. Submitting false credentials is grounds for immediate account termination and may be reported to relevant authorities.',
    ),
    LegalSection(
      heading: '3. Code of Conduct',
      body:
          'You agree to maintain professional conduct in all patient interactions, provide accurate medical information, keep patient data confidential, and comply with all applicable medical regulations and standards of care.',
    ),
    LegalSection(
      heading: '4. Platform Use',
      body:
          'The platform must not be used for unlawful purposes. You are responsible for maintaining the confidentiality of your account credentials. Sharing your account with others is strictly prohibited.',
    ),
    LegalSection(
      heading: '5. Fees & Payments',
      body:
          'Consultation fees are set by you within platform guidelines. iDoc retains a service fee as outlined in the fee schedule. Payments are processed securely through our payment gateway partners.',
    ),
    LegalSection(
      heading: '6. Intellectual Property',
      body:
          'All platform content, trademarks, and software are owned by iDoc. You retain ownership of your professional profile content but grant iDoc a license to display it on the platform.',
    ),
    LegalSection(
      heading: '7. Termination',
      body:
          'iDoc reserves the right to suspend or terminate accounts that violate these terms, receive significant patient complaints, or engage in fraudulent activity, with or without prior notice.',
    ),
    LegalSection(
      heading: '8. Limitation of Liability',
      body:
          'iDoc is a platform facilitating connections between doctors and patients. We are not liable for the quality of medical advice provided. Doctors bear full professional responsibility for their consultations.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LegalDocumentScreen(
      title: 'Terms & Conditions',
      lastUpdated: 'April 5, 2026',
      sections: _sections,
    );
  }
}