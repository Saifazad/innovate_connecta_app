import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/student_profile_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final StudentProfileModel profile;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onEditName;
  final VoidCallback? onEditProgram;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    this.onAvatarTap,
    this.onEditName,
    this.onEditProgram,
  });

  static const Color brandAmber = Color(0xFFF59E0B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color borderIndigo = Color(0xFF312E81);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const RadialGradient(
          center: Alignment(0.0, -0.6),
          radius: 1.3,
          colors: [
            Color(0xFF2E266F),
            Color(0xFF131B36),
            Color(0xFF0D1326),
          ],
        ),
        border: Border.all(color: borderIndigo.withValues(alpha: 0.6), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        children: [
          // Avatar with Camera Badge
          GestureDetector(
            onTap: onAvatarTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E293B),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                    child: _buildAvatarImage(),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: brandPurple,
                      border: Border.all(color: const Color(0xFF0F172A), width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          Text(
            'Tap to change photo',
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 14),

          // Name Box
          GestureDetector(
            onTap: onEditName,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: brandPurple.withValues(alpha: 0.45),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    profile.name.isNotEmpty ? profile.name : 'Add Full Name',
                    style: GoogleFonts.inter(
                      fontSize: 17.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFCBD5E1),
                    size: 15,
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified_rounded,
                    color: brandAmber,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Badges Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MSME Verified Student
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF451A03).withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: brandAmber.withValues(alpha: 0.5),
                    width: 0.9,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.shield_rounded,
                      color: brandAmber,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'MSME Verified Student',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: brandAmber,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Cohort 2024
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1B4B).withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                    width: 0.9,
                  ),
                ),
                child: Text(
                  profile.cohort,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFA5B4FC),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
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
        size: 46,
        color: Color(0xFF6366F1),
      ),
    );
  }
}
