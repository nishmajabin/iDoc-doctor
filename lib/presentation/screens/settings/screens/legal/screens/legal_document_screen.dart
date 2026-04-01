import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idoc_doctor_side/core/theme/color.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/widgets/legal_section.dart';
import 'package:idoc_doctor_side/presentation/screens/settings/screens/legal/widgets/legal_section_card.dart';

class LegalDocumentScreen extends StatelessWidget {
  final String title;
  final String lastUpdated;
  final List<LegalSection> sections;

  const LegalDocumentScreen({
    required this.title,
    required this.lastUpdated,
    required this.sections,
    super.key
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
              icon:  Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.gradientColor, size: 20),
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
                                color: AppColors.gradientColor,
                                letterSpacing: -0.3)),
                        const SizedBox(height: 4),
                        Text('Last updated: $lastUpdated',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.gradientColor.withValues(alpha: 0.7))),
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
                    .map((section) => LegalSectionCard(section: section))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}