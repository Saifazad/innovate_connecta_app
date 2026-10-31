import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/about_strings.dart';
import '../widgets/value_card.dart';
import '../widgets/about_bottom_nav_bar.dart';

class OurValuesScreen extends StatelessWidget {
  final bool showBottomNav;

  const OurValuesScreen({
    super.key,
    this.showBottomNav = false,
  });

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color topBarColor = Color(0xFF0A0F1D);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color subtitleColor = Color(0xFF94A3B8);

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
                    children: [
                      // --- 1. Screen Title: Our Values ---
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Our ',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.4,
                              ),
                            ),
                            TextSpan(
                              text: 'Values',
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: brandPurple,
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- 2. Screen Subtitle ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          AboutStrings.ourValuesSubtitle,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: subtitleColor,
                            height: 1.48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- 3. The 6 Value Cards ---
                      // Card 1: Student-Centric Learning
                      const ValueCard(
                        icon: Icons.school_rounded,
                        iconColor: Color(0xFFF97316),
                        iconBgColor: Color(0xFF2B1608),
                        title: AboutStrings.value1Title,
                        description: AboutStrings.value1Desc,
                      ),
                      const SizedBox(height: 14),

                      // Card 2: Excellence
                      const ValueCard(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: Color(0xFF38BDF8),
                        iconBgColor: Color(0xFF0F203D),
                        title: AboutStrings.value2Title,
                        description: AboutStrings.value2Desc,
                      ),
                      const SizedBox(height: 14),

                      // Card 3: Innovation
                      const ValueCard(
                        icon: Icons.lightbulb_outline_rounded,
                        iconColor: Color(0xFFF43F5E),
                        iconBgColor: Color(0xFF2E1022),
                        title: AboutStrings.value3Title,
                        description: AboutStrings.value3Desc,
                      ),
                      const SizedBox(height: 14),

                      // Card 4: Collaboration
                      const ValueCard(
                        icon: Icons.handshake_rounded,
                        iconColor: Color(0xFF818CF8),
                        iconBgColor: Color(0xFF16183B),
                        title: AboutStrings.value4Title,
                        description: AboutStrings.value4Desc,
                      ),
                      const SizedBox(height: 14),

                      // Card 5: Integrity
                      const ValueCard(
                        icon: Icons.shield_outlined,
                        iconColor: Color(0xFFF59E0B),
                        iconBgColor: Color(0xFF281E08),
                        title: AboutStrings.value5Title,
                        description: AboutStrings.value5Desc,
                      ),
                      const SizedBox(height: 14),

                      // Card 6: Lifelong Learning
                      const ValueCard(
                        icon: Icons.all_inclusive_rounded,
                        iconColor: brandPurple,
                        iconBgColor: Color(0xFF251239),
                        title: AboutStrings.value6Title,
                        description: AboutStrings.value6Desc,
                      ),
                      const SizedBox(height: 20),

                      // --- 4. Bottom Empowering Banner ---
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141328),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFF7E22CE)
                                .withValues(alpha: 0.45),
                            width: 1.1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AboutStrings.empowerBanner,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD8B4FE),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            showBottomNav ? const AboutBottomNavBar(selectedIndex: 2) : null,
      ),
    );
  }

  /// Top App Bar matching the mockup
  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: topBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back Button on the left
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
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
                  border: Border.all(
                    color: const Color(0xFF1E293B),
                    width: 1.1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Center Pill Badge: ABOUT ORGANIZATION
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF25103E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF9333EA).withValues(alpha: 0.6),
                width: 1.1,
              ),
            ),
            child: Text(
              AboutStrings.aboutOrganization,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: brandPurple,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
