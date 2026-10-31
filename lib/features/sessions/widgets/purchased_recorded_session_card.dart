import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/recorded_session_model.dart';
import '../views/course_preview_screen.dart';

/// Card widget for Purchased Recorded Sessions matching the Figma / app screenshot:
/// - Green '✓ Lifetime Access' badge on top-left of thumbnail
/// - '14 Hours • 18 Lessons' duration pill on bottom-right of thumbnail
/// - Play button overlay
/// - Category pill (System Design)
/// - Title & Multi-line description
/// - Divider Line
/// - Bottom Row: '🔓 Unlocked' in green on left, 'Watch Now →' purple button on right.
class PurchasedRecordedSessionCard extends StatelessWidget {
  final RecordedSessionModel session;
  final Axis orientation;

  const PurchasedRecordedSessionCard({
    super.key,
    required this.session,
    this.orientation = Axis.vertical,
  });

  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandPurple = Color(0xFF7C3AED);
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color cardBorder = Color(0xFF1E293B);

  bool get _isHorizontal => orientation == Axis.horizontal;

  void _openCourse(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CoursePreviewScreen(
          session: session.copyWith(isEnrolled: true),
          slug: session.slug,
          courseId: session.id,
        ),
      ),
    );
  }

  String get _displaySlugText {
    if (session.heading != null && session.heading!.trim().isNotEmpty) {
      return session.heading!.trim();
    }
    if (session.slug != null && session.slug!.trim().isNotEmpty) {
      return session.slug!.trim();
    }
    if (session.courseOverview != null && session.courseOverview!.trim().isNotEmpty) {
      return session.courseOverview!.trim();
    }
    return 'Learn to design scalable, reliable and production-ready software systems.';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: _isHorizontal ? 305 : double.infinity,
      borderRadius: 22,
      onTap: () => _openCourse(context),
      padding: _isHorizontal
          ? const EdgeInsets.all(14)
          : const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: _isHorizontal
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        mainAxisSize: _isHorizontal ? MainAxisSize.max : MainAxisSize.min,
        children: [
          // Top Content Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Thumbnail Banner with Lifetime Access Badge & Duration Pill
              _buildThumbnail(context),
              SizedBox(height: _isHorizontal ? 10 : 14),

              // 2. Category Pill
              _buildCategoryPill(),
              SizedBox(height: _isHorizontal ? 8 : 10),

              // 3. Course Title
              Text(
                session.title,
                style: GoogleFonts.inter(
                  fontSize: _isHorizontal ? 15 : 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.25,
                  height: 1.25,
                ),
                maxLines: _isHorizontal ? 1 : null,
                overflow: _isHorizontal ? TextOverflow.ellipsis : TextOverflow.visible,
              ),
              SizedBox(height: _isHorizontal ? 5 : 8),

              // 4. Subtitle / Slug text
              Text(
                _displaySlugText,
                style: GoogleFonts.inter(
                  fontSize: _isHorizontal ? 11.5 : 13,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.45,
                ),
                maxLines: _isHorizontal ? 3 : null,
                overflow: _isHorizontal ? TextOverflow.ellipsis : TextOverflow.visible,
              ),
            ],
          ),

          // Bottom Content Section: Divider + Unlocked Row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_isHorizontal) const SizedBox(height: 16),
              const Divider(color: cardBorder, height: 1, thickness: 1),
              SizedBox(height: _isHorizontal ? 10 : 16),
              _buildBottomRow(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final hasThumbnail = session.thumbnailUrl != null &&
        session.thumbnailUrl!.trim().isNotEmpty;
    final bannerHeight = _isHorizontal ? 115.0 : 180.0;

    return Container(
      height: bannerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(_isHorizontal ? 14 : 16),
        border: Border.all(color: cardBorder, width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_isHorizontal ? 14 : 16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail image with error & loading fallbacks
            if (hasThumbnail)
              Image.network(
                session.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildFallbackBanner(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildFallbackBanner();
                },
              )
            else
              _buildFallbackBanner(),

            // Scrim overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.50),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Top-Left Badge: '✓ Lifetime Access'
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _isHorizontal ? 8 : 10,
                  vertical: _isHorizontal ? 3.5 : 4.5,
                ),
                decoration: BoxDecoration(
                  color: emeraldGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: emeraldGreen.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: _isHorizontal ? 11.5 : 13,
                    ),
                    const SizedBox(width: 4.5),
                    Text(
                      'Lifetime Access',
                      style: GoogleFonts.inter(
                        fontSize: _isHorizontal ? 10 : 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Frosted Play Button
            Center(
              child: GestureDetector(
                onTap: () => _openCourse(context),
                child: Container(
                  width: _isHorizontal ? 40 : 48,
                  height: _isHorizontal ? 40 : 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.50),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.40),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.40),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: _isHorizontal ? 22 : 28,
                  ),
                ),
              ),
            ),

            // Bottom-Right Pill: '14 Hours • 18 Lessons'
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _isHorizontal ? 8 : 10,
                  vertical: _isHorizontal ? 3.5 : 4.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  '${session.duration} • ${session.lessons.toLowerCase().contains("lesson") ? session.lessons : "${session.lessons} Lessons"}',
                  style: GoogleFonts.inter(
                    fontSize: _isHorizontal ? 10.5 : 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          color: Colors.white.withValues(alpha: 0.25),
          size: _isHorizontal ? 38 : 50,
        ),
      ),
    );
  }

  Widget _buildCategoryPill() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isHorizontal ? 10 : 12,
        vertical: _isHorizontal ? 3.5 : 4.5,
      ),
      decoration: BoxDecoration(
        color: brandOrange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: brandOrange.withValues(alpha: 0.40),
          width: 1.0,
        ),
      ),
      child: Text(
        session.categoryName,
        style: GoogleFonts.inter(
          fontSize: _isHorizontal ? 11 : 12,
          fontWeight: FontWeight.w600,
          color: brandOrange,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left: Green '🔓 Unlocked'
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_open_rounded,
              color: emeraldGreen,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Unlocked',
              style: GoogleFonts.inter(
                fontSize: _isHorizontal ? 12.5 : 14,
                fontWeight: FontWeight.w600,
                color: emeraldGreen,
              ),
            ),
          ],
        ),

        // Right: 'Watch Now →' Button
        GestureDetector(
          onTap: () => _openCourse(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _isHorizontal ? 14 : 20,
              vertical: _isHorizontal ? 8 : 10,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: brandPurple.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Watch Now',
                  style: GoogleFonts.inter(
                    fontSize: _isHorizontal ? 12 : 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '→',
                  style: GoogleFonts.inter(
                    fontSize: _isHorizontal ? 12 : 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

