import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service_item.dart';

class ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.service,
    this.onTap,
  });

  static const Color cardBg = Color(0xFF0F172A);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color subtitleColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      constraints: const BoxConstraints(minHeight: 290),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.white.withValues(alpha: 0.04),
          highlightColor: Colors.white.withValues(alpha: 0.02),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Icon Box
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: service.iconBgColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          service.icon,
                          color: service.iconColor,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Service Title
                    Text(
                      service.title,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.2,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      service.description,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: subtitleColor,
                        height: 1.45,
                      ),
                    ),

                    // Benefits Section (if present)
                    if (service.benefits != null &&
                        service.benefits!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 17,
                            height: 17,
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B5BF8),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 11,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Benefits:',
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4F6BFF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 23),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: service.benefits!.map((b) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              child: Text(
                                b,
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFCBD5E1),
                                  height: 1.35,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 14),

                // Tags / Badges pinned to bottom
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: service.tags.map((tag) {
                    return _buildTagBadge(tag);
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTagBadge(String tag) {
    final bool isAmber = service.isAmberTheme;

    final Color bgColor =
        isAmber ? const Color(0xFF281E08) : const Color(0xFF231238);
    final Color borderColor = isAmber
        ? const Color(0xFFD97706).withValues(alpha: 0.5)
        : const Color(0xFF7E22CE).withValues(alpha: 0.5);
    final Color textColor =
        isAmber ? const Color(0xFFF59E0B) : const Color(0xFFC084FC);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: Text(
        tag,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
