import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/widgets.dart';
import '../models/live_session_model.dart';
import '../models/recorded_session_model.dart';
import '../views/course_preview_screen.dart';

class SessionDetailDialog {
  /// Backward compatible generic show for live sessions
  static void show(BuildContext context, LiveSessionModel session) {
    showLiveSession(context, session);
  }

  static void showLiveSession(BuildContext context, LiveSessionModel session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _LiveSessionSheet(session: session),
    );
  }

  static void showRecordedSession(BuildContext context, RecordedSessionModel session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _RecordedSessionSheet(session: session),
    );
  }
}

class _LiveSessionSheet extends StatelessWidget {
  final LiveSessionModel session;

  const _LiveSessionSheet({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF334155), width: 1.2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag indicator
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Category & Badge Row
            Row(
              children: [
                AppBadge.category(
                  label: session.categoryName,
                  color: const Color(0xFFF59E0B),
                  uppercase: true,
                  borderRadius: 8,
                ),
                if (session.badgeText != null) ...[
                  const SizedBox(width: 8),
                  AppBadge.status(
                    label: session.badgeText!,
                    color: session.badgeColor ?? const Color(0xFFEF4444),
                    withDot: false,
                    borderRadius: 8,
                    fontSize: 11,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ],
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              session.title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              session.description,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),

            // Details info tiles
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, size: 18, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 10),
                      Text(
                        'Date: ',
                        style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                      ),
                      Expanded(
                        child: Text(
                          session.date,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF1E293B), height: 18),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 18, color: Color(0xFF38BDF8)),
                      const SizedBox(width: 10),
                      Text(
                        'Schedule: ',
                        style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                      ),
                      Expanded(
                        child: Text(
                          session.schedule,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (session.instructorName != null) ...[
                    const Divider(color: Color(0xFF1E293B), height: 18),
                    Row(
                      children: [
                        const Icon(Icons.person_pin_rounded, size: 18, color: Color(0xFFA855F7)),
                        const SizedBox(width: 10),
                        Text(
                          'Instructor: ',
                          style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                        ),
                        Expanded(
                          child: Text(
                            session.instructorName!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Price & Reserve Button
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Participation Fee',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 2),
                    PriceTag(
                      currentPrice: session.fee,
                      originalPrice: session.originalFee,
                      currentPriceSize: 22,
                      originalPriceSize: 14,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('🎉 Seat reserved successfully for "${session.title}"!'),
                          backgroundColor: const Color(0xFF7C3AED),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                    ),
                    child: Text(
                      'Reserve Seat',
                      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordedSessionSheet extends StatelessWidget {
  final RecordedSessionModel session;

  const _RecordedSessionSheet({required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFF334155), width: 1.2),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),

            Row(
              children: [
                AppBadge.category(
                  label: session.categoryName,
                  color: const Color(0xFFA855F7),
                  uppercase: true,
                  borderRadius: 8,
                ),
                const SizedBox(width: 8),
                AppBadge(
                  label: '${session.rating}',
                  textColor: Colors.white,
                  backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.15),
                  fontSize: 11,
                  borderRadius: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  trailing: const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              session.title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            if (session.heading != null && session.heading!.isNotEmpty)
              Text(
                session.heading!,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF94A3B8),
                  height: 1.5,
                ),
              ),
            const SizedBox(height: 16),

            // Meta badges
            Row(
              children: [
                _buildBadge(Icons.timer_outlined, session.duration),
                const SizedBox(width: 10),
                _buildBadge(Icons.play_lesson_outlined, session.lessons),
                const SizedBox(width: 10),
                _buildBadge(Icons.all_inclusive_rounded, 'Lifetime Access'),
              ],
            ),
            const SizedBox(height: 20),

            // Pricing & Preview Button
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Course',
                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8)),
                    ),
                    const SizedBox(height: 2),
                    PriceTag(
                      currentPrice: session.discountPrice,
                      originalPrice: session.originalPrice,
                      currentPriceColor: Colors.white,
                      currentPriceSize: 22,
                      originalPriceSize: 14,
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final nav = Navigator.of(context);
                      nav.pop();
                      nav.push(
                        MaterialPageRoute(
                          builder: (_) => CoursePreviewScreen(
                            session: session,
                            slug: session.slug,
                            courseId: session.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Preview Course',
                          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return AppBadge.meta(
      icon: icon,
      label: label,
      iconColor: const Color(0xFFA855F7),
      textColor: Colors.white70,
      backgroundColor: const Color(0xFF131B2E),
      borderColor: const Color(0xFF1E293B),
      fontSize: 11.5,
      iconSize: 14,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    );
  }
}
