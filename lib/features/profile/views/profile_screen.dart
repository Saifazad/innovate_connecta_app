import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../view_models/profile_view_model.dart';
import '../widgets/profile/profile_header_card.dart';
import '../widgets/profile/personal_info_tile.dart';
import '../widgets/common/profile_section_card.dart';
import '../widgets/common/profile_menu_tile.dart';

import 'resume_screen.dart';
import 'certificates_screen.dart';
import 'security_screen.dart';
import 'feedback_screen.dart';
import '../../contact/views/contact_screen.dart';
import '../../auth/views/login_screen.dart';
import '../../about/widgets/about_bottom_nav_bar.dart';
import '../../../app/main_navigation_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;

  const ProfileScreen({
    super.key,
    this.showBottomNav = false,
    this.onTabSelected,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBorder = Color(0xFF1E293B);
  bool _isSettingsExpanded = false;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel.instance;
    _viewModel.fetchProfile();
  }

  Future<void> _onPickProfilePhoto() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.image,
      );
      if (file != null && file.path != null && file.path!.isNotEmpty) {
        await _viewModel.updateField(avatarUrl: file.path);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo updated successfully!'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not pick photo: $e'),
          backgroundColor: const Color(0xFFF43F5E),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showEditFieldDialog({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSave,
  }) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: cardBorder, width: 1.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit $title',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white70)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      onSave(controller.text);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA855F7),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: cardBorder, width: 1.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 26,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Log Out',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to log out of InnoVate Connecta?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: cardBorder),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await _viewModel.logout();
                        if (!mounted) return;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Log Out'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          bottom: !widget.showBottomNav,
          child: Column(
            children: [
              _buildTopAppBar(context),
              Expanded(
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    final profile = _viewModel.profile;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Profile Header Card
                          ProfileHeaderCard(
                            profile: profile,
                            onAvatarTap: _onPickProfilePhoto,
                            onEditName: () {
                              _showEditFieldDialog(
                                title: 'Full Name',
                                initialValue: profile.name,
                                onSave: (val) => _viewModel.updateField(name: val.trim()),
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // 2. Personal Details Section
                          _buildSectionTitle('PERSONAL DETAILS'),
                          const SizedBox(height: 10),
                          ProfileSectionCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                PersonalInfoTile(
                                  icon: Icons.mail_outline_rounded,
                                  label: 'Email Address',
                                  value: profile.email.isNotEmpty ? profile.email : 'Add Email Address',
                                  badgeText: profile.isEmailVerified ? 'Verified' : null,
                                  badgeColor: const Color(0xFF10B981),
                                  onEdit: () {
                                    _showEditFieldDialog(
                                      title: 'Email Address',
                                      initialValue: profile.email,
                                      onSave: (val) => _viewModel.updateField(email: val.trim()),
                                    );
                                  },
                                ),
                                PersonalInfoTile(
                                  icon: Icons.phone_outlined,
                                  label: 'Phone Number',
                                  value: profile.phone.isNotEmpty ? profile.phone : 'Add Phone Number',
                                  onEdit: () {
                                    _showEditFieldDialog(
                                      title: 'Phone Number',
                                      initialValue: profile.phone,
                                      onSave: (val) => _viewModel.updateField(phone: val.trim()),
                                    );
                                  },
                                ),
                                PersonalInfoTile(
                                  icon: Icons.school_outlined,
                                  label: 'Your Field / Category',
                                  value: profile.fieldTitle,
                                  showDivider: false,
                                  onEdit: () {
                                    _showEditFieldDialog(
                                      title: 'Your Field / Category',
                                      initialValue: profile.field,
                                      onSave: (val) => _viewModel.updateField(field: val.trim()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 3. Documents Section
                          _buildSectionTitle('DOCUMENTS'),
                          const SizedBox(height: 10),
                          ProfileSectionCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                ProfileMenuTile(
                                  icon: Icons.description_outlined,
                                  iconColor: const Color(0xFF38BDF8),
                                  iconBgColor: const Color(0xFF0C2440),
                                  title: 'My Resume',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const ResumeScreen()),
                                    );
                                  },
                                ),
                                ProfileMenuTile(
                                  icon: Icons.workspace_premium_outlined,
                                  iconColor: const Color(0xFF34D399),
                                  iconBgColor: const Color(0xFF0B2E24),
                                  title: 'Certificates',
                                  showDivider: false,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const CertificatesScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // 4. Preferences & Support Section
                          _buildSectionTitle('PREFERENCES & SUPPORT'),
                          const SizedBox(height: 10),
                          ProfileSectionCard(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: [
                                // Settings Expandable Dropdown Tile
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _isSettingsExpanded = !_isSettingsExpanded;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 38,
                                              height: 38,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF261942),
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: const Color(0xFFC084FC).withValues(alpha: 0.3),
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.settings_outlined,
                                                color: Color(0xFFC084FC),
                                                size: 19,
                                              ),
                                            ),
                                            const SizedBox(width: 14),
                                            Expanded(
                                              child: Text(
                                                'Settings',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            AnimatedRotation(
                                              turns: _isSettingsExpanded ? 0.5 : 0.0,
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOut,
                                              child: const Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                color: Color(0xFF64748B),
                                                size: 22,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    AnimatedSize(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOutCubic,
                                      child: _isSettingsExpanded
                                          ? Container(
                                              margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF090D16),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: cardBorder,
                                                  width: 1.0,
                                                ),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) => const SecurityScreen(),
                                                    ),
                                                  );
                                                },
                                                borderRadius: BorderRadius.circular(12),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 32,
                                                        height: 32,
                                                        decoration: BoxDecoration(
                                                          color: const Color(0xFF261942),
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: const Icon(
                                                          Icons.lock_outline_rounded,
                                                          color: Color(0xFFC084FC),
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'Change Password',
                                                              style: GoogleFonts.inter(
                                                                fontSize: 13.5,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                            const SizedBox(height: 2),
                                                            Text(
                                                              'Update account password',
                                                              style: GoogleFonts.inter(
                                                                fontSize: 11,
                                                                color: const Color(0xFF94A3B8),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons.chevron_right_rounded,
                                                        color: Color(0xFF64748B),
                                                        size: 18,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    const Divider(
                                      color: Color(0xFF1E293B),
                                      height: 1,
                                      indent: 14,
                                      endIndent: 14,
                                    ),
                                  ],
                                ),
                                ProfileMenuTile(
                                  icon: Icons.help_outline_rounded,
                                  iconColor: const Color(0xFF60A5FA),
                                  iconBgColor: const Color(0xFF131D33),
                                  title: 'Help & Support Desk',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const ContactScreen()),
                                    );
                                  },
                                ),
                                ProfileMenuTile(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  iconColor: const Color(0xFF2DD4BF),
                                  iconBgColor: const Color(0xFF0F2E2C),
                                  title: 'Feedback',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                                    );
                                  },
                                ),
                                ProfileMenuTile(
                                  icon: Icons.logout_rounded,
                                  iconColor: const Color(0xFFF43F5E),
                                  iconBgColor: const Color(0xFF33141E),
                                  title: 'Log Out',
                                  isDestructive: true,
                                  showDivider: false,
                                  onTap: _showLogoutDialog,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.showBottomNav
            ? AboutBottomNavBar(
                selectedIndex: 4,
                centerLabel: 'Dashboard',
                onItemTapped: (index) {
                  if (widget.onTabSelected != null) {
                    widget.onTabSelected!(index);
                    return;
                  }
                  MainNavigationScreen.switchTab(context, index);
                },
              )
            : null,
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else if (widget.onTabSelected != null) {
                widget.onTabSelected!(0);
              } else {
                MainNavigationScreen.switchTab(context, 0);
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                shape: BoxShape.circle,
                border: Border.all(color: cardBorder, width: 1.1),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Student Profile',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF94A3B8),
        letterSpacing: 0.9,
      ),
    );
  }
}
