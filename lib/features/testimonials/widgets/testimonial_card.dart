import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/testimonial_model.dart';

class TestimonialCard extends StatelessWidget {
  final TestimonialModel testimonial;

  const TestimonialCard({
    super.key,
    required this.testimonial,
  });

  static const Color cardBg = Color(0xFF0F172A);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color starGold = Color(0xFFF59E0B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color verifiedBlue = Color(0xFF38BDF8);
  static const Color textSecondary = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Top Row: User Avatar, Name, Designation & Quote Watermark ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            testimonial.name,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (testimonial.isVerified) ...[
                          const SizedBox(width: 5),
                          const Tooltip(
                            message: 'Verified Learner',
                            child: Icon(
                              Icons.verified_rounded,
                              color: verifiedBlue,
                              size: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    if (testimonial.designation.isNotEmpty)
                      Text(
                        testimonial.designation,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Quote watermark badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: brandPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.format_quote_rounded,
                    color: brandPurple,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // --- Star Rating & Featured Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ...List.generate(5, (index) {
                    final isFilled = index < testimonial.rating.floor();
                    return Icon(
                      isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isFilled ? starGold : const Color(0xFF475569),
                      size: 18,
                    );
                  }),
                  const SizedBox(width: 6),
                  Text(
                    testimonial.rating.toStringAsFixed(1),
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: starGold,
                    ),
                  ),
                ],
              ),
              if (testimonial.isFeatured)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: starGold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: starGold.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: starGold,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'FEATURED',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: starGold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // --- Review Text ---
          Text(
            testimonial.review,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFCBD5E1),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          // --- Date Footer ---
          if (testimonial.createdAt != null)
            Text(
              _formatDate(testimonial.createdAt!),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (testimonial.avatarUrl != null && testimonial.avatarUrl!.isNotEmpty) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: brandPurple.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            testimonial.avatarUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _buildFallbackAvatar(),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: const Color(0xFF1E293B),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: brandPurple,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            brandPurple,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: brandPurple.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          testimonial.initials,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatDate(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (_) {
      return '';
    }
  }
}
