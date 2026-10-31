import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/about_strings.dart';
import '../../../shared/widgets/app_info_tile.dart';
import '../../../shared/widgets/app_stat_card.dart';
import '../widgets/about_bottom_nav_bar.dart';
import 'our_values_screen.dart';

class AboutScreen extends StatelessWidget {
  final bool showBottomNav;

  const AboutScreen({super.key, this.showBottomNav = false});

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color topBarColor = Color(0xFF0A0F1D);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color paragraphColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: darkCanvas,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: darkCanvas,
        body: SafeArea(
          bottom: !showBottomNav,
          child: Column(
            children: [
              _buildTopAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 1. Eyebrow Tag: WHO WE ARE ---
                      Text(
                        AboutStrings.whoWeAre,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: brandOrange,
                          letterSpacing: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // --- 2. Main Title: About InnoVate Connecta ---
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AboutStrings.aboutPrefix,
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                            ),
                            TextSpan(
                              text: 'InnoVate ',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                            ),
                            TextSpan(
                              text: 'Connecta',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: brandOrange,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- 3. Paragraph 1 ---
                      Text(
                        AboutStrings.introParagraph1,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: paragraphColor,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // --- 4. Paragraph 2 ---
                      Text(
                        AboutStrings.introParagraph2,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: paragraphColor,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 22),

                      // --- 5. Feature Badges / Highlights ---
                      const Wrap(
                        spacing: 18,
                        runSpacing: 12,
                        children: [
                          AppInfoTile(
                            icon: Icons.check,
                            label: AboutStrings.highlightIndustryConnections,
                          ),
                          AppInfoTile(
                            icon: Icons.verified_user_rounded,
                            label: AboutStrings.highlightMsmeRegistered,
                          ),
                          AppInfoTile(
                            icon: Icons.school_rounded,
                            label: AboutStrings.highlightExpertMentorship,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // --- 6. Our Vision Card ---
                      const AppStatCard.pillar(
                        icon: Icons.remove_red_eye_rounded,
                        iconColor: Color(0xFF60A5FA),
                        iconBgColor: Color(0xFF14203D),
                        title: AboutStrings.visionTitle,
                        description: AboutStrings.visionDescription,
                      ),
                      const SizedBox(height: 16),

                      // --- 7. Our Mission Card ---
                      const AppStatCard.pillar(
                        icon: Icons.track_changes_rounded,
                        iconColor: Color(0xFFFB923C),
                        iconBgColor: Color(0xFF2B1B10),
                        title: AboutStrings.missionTitle,
                        description: AboutStrings.missionDescription,
                      ),
                      const SizedBox(height: 16),

                      // --- 8. Our Values Card (with See More Navigation) ---
                      AppStatCard.pillar(
                        icon: Icons.sync_rounded,
                        iconColor: brandPurple,
                        iconBgColor: const Color(0xFF26153B),
                        title: AboutStrings.valuesTitle,
                        description: AboutStrings.valuesSummary,
                        trailing: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const OurValuesScreen(showBottomNav: false),
                              ),
                            );
                          },
                          child: Text(
                            AboutStrings.seeMore,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: brandPurple,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OurValuesScreen(showBottomNav: false),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: showBottomNav
            ? const AboutBottomNavBar(selectedIndex: 2)
            : null,
      ),
    );
  }

  /// Top App Bar matching the mockup
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: topBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF1E293B), width: 1.1),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      AboutStrings.aboutUsTitle,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: brandOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'InnoVate ',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      TextSpan(
                        text: 'Connecta',
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: brandPurple,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // MSME Verified Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF281E08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD97706).withValues(alpha: 0.55),
                width: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFFF59E0B),
                  size: 13,
                ),
                const SizedBox(width: 5),
                Text(
                  AboutStrings.msmeVerified,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFF59E0B),
                    letterSpacing: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
