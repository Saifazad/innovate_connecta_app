import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/views/services_screen.dart';
import '../../../app/main_navigation_screen.dart';
import '../../gallery/views/gallery_screen.dart';
import '../../contact/views/contact_screen.dart';
import '../../about/views/about_screen.dart';
import '../../profile/views/security_screen.dart';
import '../../profile/view_models/profile_view_model.dart';
import '../../profile/models/student_profile_model.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  static const Color drawerBg = Color(0xFF090D16);
  static const Color itemBg = Color(0xFF101726);
  static const Color borderCol = Color(0xFF1E293B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandAmber = Color(0xFFF59E0B);
  static const Color brandIndigo = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: drawerBg,
      child: SafeArea(
        child: ListenableBuilder(
          listenable: ProfileViewModel.instance,
          builder: (context, _) {
            final profile = ProfileViewModel.instance.profile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Header: User Profile with Verified Badge, Cohort, and Close Icon
                _buildDrawerHeader(context, profile),

                const Divider(color: borderCol, height: 1),

                // Navigation Cards List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    children: [
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.home_rounded,
                        title: 'Home',
                        subtitle: 'Overview & feed',
                        isSelected: true,
                        onTap: () {
                          Navigator.of(context).pop();
                          MainNavigationScreen.switchTab(context, 0);
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.info_outline_rounded,
                        title: 'About',
                        subtitle: 'Mission, team & vision',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AboutScreen(showBottomNav: false),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.business_center_outlined,
                        title: 'Services',
                        subtitle: 'Courses & mentoring',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ServicesScreen(showBottomNav: false),
                            ),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.photo_library_outlined,
                        title: 'Gallery',
                        subtitle: 'Bootcamps & moments',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const GalleryScreen()),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.chat_bubble_outline_rounded,
                        title: 'Contacts',
                        subtitle: 'Support & enquiries',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ContactScreen()),
                          );
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'Preferences & security',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SecurityScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Divider(color: borderCol, height: 1),

                // Drawer Footer: Version & MSME Registration info
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'InnoVate Connecta v2.4',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'MSME Reg. #UDYAM-DL-03-0012',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, StudentProfileModel profile) {
    final displayName = profile.name.isNotEmpty ? profile.name : 'Add Full Name';
    final displayEmail = profile.email.isNotEmpty ? profile.email : 'Add Email Address';
    final displayEducation = profile.degree.isNotEmpty
        ? profile.programTitle
        : (profile.university.isNotEmpty ? profile.university : 'Add Education');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar with Online Green Badge
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  MainNavigationScreen.switchTab(context, 4);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF131B2E),
                        border: Border.all(
                          color: brandIndigo.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: _buildAvatarImage(profile),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10B981),
                          border: Border.all(color: drawerBg, width: 2),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            size: 8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // User Info (Name, Verified badge, Email, Degree)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    MainNavigationScreen.switchTab(context, 4);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.verified_rounded,
                            color: brandAmber,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayEmail,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayEducation,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFCBD5E1),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Close Button (X)
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderCol, width: 1.1),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white70,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Cohort Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: brandIndigo.withValues(alpha: 0.45),
                width: 0.9,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF10B981),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  profile.cohort.isNotEmpty ? profile.cohort : 'Student Cohort • 2025',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFA5B4FC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage(StudentProfileModel profile) {
    final url = profile.avatarUrl;
    if (url != null && url.isNotEmpty) {
      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
        );
      }
      try {
        final file = File(url);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
          );
        }
      } catch (_) {}
    }
    return _buildAvatarFallback();
  }

  Widget _buildAvatarFallback() {
    return const Center(
      child: Icon(
        Icons.person_rounded,
        size: 30,
        color: brandIndigo,
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2E124D) : itemBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? brandPurple.withValues(alpha: 0.5) : borderCol,
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? brandPurple.withValues(alpha: 0.25)
                        : const Color(0xFF131B2E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? brandPurple.withValues(alpha: 0.4)
                          : const Color(0xFF1E293B),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? brandPurple : const Color(0xFF818CF8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Chevron
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
