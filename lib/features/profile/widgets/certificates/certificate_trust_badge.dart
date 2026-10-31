import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CertificateTrustBadge extends StatelessWidget {
  const CertificateTrustBadge({super.key});

  static const Color greenVerified = Color(0xFF10B981);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.verified_rounded,
                color: greenVerified,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'MSME & ISO 9001:2015 Verified',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: greenVerified,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'All certificates are verified and issued by Innovate Connect Academy.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
