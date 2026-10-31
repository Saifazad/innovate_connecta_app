import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSectionHeader extends StatelessWidget {
  final String eyebrow;
  final String titlePrefix;
  final String titleHighlight;
  final String? titleSuffix;
  final String? subtitle;
  final String actionLabel;
  final VoidCallback? onActionTap;

  const HomeSectionHeader({
    super.key,
    required this.eyebrow,
    required this.titlePrefix,
    required this.titleHighlight,
    this.titleSuffix,
    this.subtitle,
    this.actionLabel = 'View All →',
    this.onActionTap,
  });

  static const Color goldEyebrow = Color(0xFFF59E0B);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color subtitleColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow
        Text(
          eyebrow.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: goldEyebrow,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),

        // Main Title Row with View All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: titlePrefix,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextSpan(
                      text: titleHighlight,
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: brandPurple,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (titleSuffix != null)
                      TextSpan(
                        text: titleSuffix,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (onActionTap != null)
              GestureDetector(
                onTap: onActionTap,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Text(
                    actionLabel,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: brandPurple,
                    ),
                  ),
                ),
              ),
          ],
        ),

        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
