import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared/widgets/widgets.dart';

class LiveSessionData {
  final String category;
  final String? badgeText;
  final Color? badgeColor;
  final String title;
  final String description;
  final String date;
  final String fee;
  final String originalFee;

  const LiveSessionData({
    required this.category,
    this.badgeText,
    this.badgeColor,
    required this.title,
    required this.description,
    required this.date,
    required this.fee,
    required this.originalFee,
  });

  static const List<LiveSessionData> sampleSessions = [
    LiveSessionData(
      category: 'System Design',
      badgeText: 'Popular',
      badgeColor: Color(0xFFF59E0B),
      title: 'Master on Cloud',
      description:
          'Practical architectural hands-on masterclass with real-world system scalability.',
      date: '12 – 26 Oct 2026 (14 Days)',
      fee: '₹100',
      originalFee: '₹199',
    ),
    LiveSessionData(
      category: 'Corporate Legal',
      badgeText: 'Trending',
      badgeColor: Color(0xFF38BDF8),
      title: 'Career On PATENTS & IP',
      description:
          'Take your intellectual property career forward with patent filing, IP licensing, and global trends.',
      date: '5 – 19 Nov 2026 (14 Days)',
      fee: '₹150',
      originalFee: '₹299',
    ),
    LiveSessionData(
      category: 'AI Engineering',
      badgeText: 'Upcoming',
      badgeColor: Color(0xFF34D399),
      title: 'Generative AI & LLMs',
      description:
          'Build enterprise RAG pipelines, fine-tune models, and deploy scalable AI agents.',
      date: '1 – 15 Dec 2026 (14 Days)',
      fee: '₹199',
      originalFee: '₹399',
    ),
  ];
}

class HomeLiveSessionCard extends StatelessWidget {
  final LiveSessionData session;

  const HomeLiveSessionCard({
    super.key,
    required this.session,
  });

  static const Color cardBorder = Color(0xFF1E293B);
  static const Color brandOrange = Color(0xFFF97316);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      width: 275,
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Category + Badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      session.category,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: brandOrange,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (session.badgeText != null)
                    AppBadge.status(
                      label: session.badgeText!,
                      color: session.badgeColor ?? brandOrange,
                      withDot: false,
                      fontSize: 10.5,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                session.title,
                style: GoogleFonts.inter(
                  fontSize: 16.5,
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
                  fontSize: 11.5,
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
                              color: brandOrange,
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

          const SizedBox(height: 14),

          // Action Buttons: View Details & Reserve Seat
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${session.title} details: Registration opens soon!',
                        ),
                        backgroundColor: const Color(0xFF1E293B),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
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
                    backgroundColor: const Color(0xFF6366F1),
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
