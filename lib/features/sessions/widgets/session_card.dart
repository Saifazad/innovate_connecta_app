import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/live_session_model.dart';
import '../models/recorded_session_model.dart';
import '../views/course_preview_screen.dart';
import 'session_detail_dialog.dart';

/// Unified Session Card architecture for Live and Recorded Sessions.
/// Eliminates styling and layout redundancy across horizontal and vertical orientations.

class LiveSessionCard extends StatelessWidget {
  final LiveSessionModel session;
  final Axis orientation;

  const LiveSessionCard({
    super.key,
    required this.session,
    this.orientation = Axis.horizontal,
  });

  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandAmber = Color(0xFFF59E0B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color cardBorder = Color(0xFF1E293B);

  bool get _isHorizontal => orientation == Axis.horizontal;

  @override
  Widget build(BuildContext context) {
    final badgeColor = session.badgeColor ?? (_isHorizontal ? const Color(0xFFEF4444) : brandOrange);
    final badgeText = session.badgeText ?? (_isHorizontal ? 'Live Soon' : 'Popular');

    return AppCard(
      width: _isHorizontal ? 295 : double.infinity,
      borderRadius: _isHorizontal ? 22 : 20,
      padding: EdgeInsets.all(_isHorizontal ? 16 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: _isHorizontal ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          // Top Row: Category + Status Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _isHorizontal
                        ? AppBadge.category(
                            label: session.categoryName,
                            color: brandAmber,
                            uppercase: true,
                            fontSize: 10,
                            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                          )
                        : Text(
                            session.categoryName,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: brandOrange,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  const SizedBox(width: 8),
                  AppBadge.status(
                    label: badgeText,
                    color: badgeColor,
                    withDot: _isHorizontal,
                    fontSize: _isHorizontal ? 10 : 11,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                session.title,
                style: GoogleFonts.inter(
                  fontSize: _isHorizontal ? 16 : 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),

              // Description
              Text(
                session.description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Date Info
              Row(
                children: [
                  const Text('📅 ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Date: ',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textMuted,
                            ),
                          ),
                          TextSpan(
                            text: session.date,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Fee Info
              Row(
                children: [
                  const Text('₹ ', style: TextStyle(fontSize: 12, color: textMuted)),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Participation Fee: ',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: textMuted,
                            ),
                          ),
                          TextSpan(
                            text: session.fee,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: brandAmber,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: session.originalFee,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: _isHorizontal ? 14 : 16),

          // Action Buttons: View Details & Reserve Seat
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => SessionDetailDialog.showLiveSession(context, session),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: cardBorder, width: 1.0),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'View Details',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Seat reservation confirmed for ${session.title}!'),
                        backgroundColor: const Color(0xFF7C3AED),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Reserve Seat',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecordedSessionCard extends StatelessWidget {
  final RecordedSessionModel session;
  final Axis orientation;

  const RecordedSessionCard({
    super.key,
    required this.session,
    this.orientation = Axis.horizontal,
  });

  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandPurple = Color(0xFF7C3AED);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color cardBorder = Color(0xFF1E293B);

  bool get _isHorizontal => orientation == Axis.horizontal;

  void _openCoursePreview(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CoursePreviewScreen(
          session: session,
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
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: _isHorizontal ? 305 : double.infinity,
      borderRadius: 22,
      onTap: () => _openCoursePreview(context),
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
          // Top Content: Thumbnail, Category Badge, Title, Full Slug text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Course Thumbnail Banner with Play Button and Duration Pill
              _buildThumbnail(context),
              SizedBox(height: _isHorizontal ? 10 : 14),

              // 2. Category Badge Pill
              _buildCategoryPill(),
              SizedBox(height: _isHorizontal ? 8 : 10),

              // 3. Course Title
              Text(
                session.title,
                style: GoogleFonts.inter(
                  fontSize: _isHorizontal ? 14.5 : 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.25,
                  height: 1.25,
                ),
                maxLines: _isHorizontal ? 1 : null,
                overflow: _isHorizontal ? TextOverflow.ellipsis : TextOverflow.visible,
              ),
              SizedBox(height: _isHorizontal ? 5 : 8),

              // 4. Course Subtitle / Slug text / Description (shown fully without being cut off)
              Text(
                _displaySlugText,
                style: GoogleFonts.inter(
                  fontSize: _isHorizontal ? 11.5 : 13,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                  height: 1.4,
                ),
                maxLines: _isHorizontal ? 3 : null,
                overflow: _isHorizontal ? TextOverflow.ellipsis : TextOverflow.visible,
              ),
            ],
          ),

          // Bottom Content: Divider Line + Bottom Row (Price & Preview Course button pinned at bottom)
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
    final bannerHeight = _isHorizontal ? 110.0 : 180.0;

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
            // Thumbnail image from API with network fallback
            if (hasThumbnail)
              Image.network(
                session.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallbackBanner(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildFallbackBanner();
                },
              )
            else
              _buildFallbackBanner(),

            // Scrim overlay for contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.45),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Centered Frosted / Translucent Play Button
            Center(
              child: GestureDetector(
                onTap: () => _openCoursePreview(context),
                child: Container(
                  width: _isHorizontal ? 40 : 48,
                  height: _isHorizontal ? 40 : 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.48),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
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

            // Bottom Right Pill: "14 Hours • 18 Lessons"
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
        // Prices: ₹3,999 and strikethrough original price on baseline
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  session.discountPrice,
                  style: GoogleFonts.inter(
                    fontSize: _isHorizontal ? 15.5 : 19.5,
                    fontWeight: FontWeight.w800,
                    color: brandOrange,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(width: 8),
                if (session.originalPrice.isNotEmpty)
                  Text(
                    session.originalPrice,
                    style: GoogleFonts.inter(
                      fontSize: _isHorizontal ? 11.5 : 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Preview Course Button with Arrow
        GestureDetector(
          onTap: () => _openCoursePreview(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _isHorizontal ? 12 : 20,
              vertical: _isHorizontal ? 8 : 11,
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
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Preview Course',
                  style: GoogleFonts.inter(
                    fontSize: _isHorizontal ? 11.5 : 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '→',
                  style: GoogleFonts.inter(
                    fontSize: _isHorizontal ? 11.5 : 13.5,
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

