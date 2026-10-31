import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/services_strings.dart';
import '../models/service_item.dart';
import '../widgets/service_card.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../../shared/widgets/widgets.dart';

class ServicesScreen extends StatelessWidget {
  final bool showBottomNav;

  const ServicesScreen({super.key, this.showBottomNav = false});

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color topBarColor = Color(0xFF0A0F1D);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color subtitleColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    const services = ServiceItem.defaultServices;

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
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Screen Heading: Our Services (All Purple) ---
                      Text(
                        '${ServicesStrings.titlePrefix}${ServicesStrings.titleHighlight}',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: brandPurple,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // --- Subtitle ---
                      Text(
                        ServicesStrings.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          color: subtitleColor,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- 2-Column Grid of Service Cards (Matching Heights) ---
                      // Row 1: Career Guidance | Upskilling Programs
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: ServiceCard(service: services[0])),
                            const SizedBox(width: 12),
                            Expanded(child: ServiceCard(service: services[1])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Row 2: Workshops & Training | Internship Assistance
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: ServiceCard(service: services[2])),
                            const SizedBox(width: 12),
                            Expanded(child: ServiceCard(service: services[3])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Row 3: Corporate Sessions | Learning Resources
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: ServiceCard(service: services[4])),
                            const SizedBox(width: 12),
                            Expanded(child: ServiceCard(service: services[5])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: showBottomNav
            ? const AboutBottomNavBar(selectedIndex: 2, centerLabel: 'Services')
            : null,
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      color: topBarColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Back Button
          const AppBackButton(
            size: 38,
            borderRadius: 10,
            iconSize: 16,
          ),
          const SizedBox(width: 14),

          // Header Text: InnoVate (White) Connecta (Orange)
          const BrandLogo(fontSize: 16),
        ],
      ),
    );
  }
}
