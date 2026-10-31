import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumeUploadBox extends StatelessWidget {
  final VoidCallback onTap;

  const ResumeUploadBox({super.key, required this.onTap});

  static const Color brandPurple = Color(0xFFA855F7);
  static const Color borderCol = Color(0xFF382B5F);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1527),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderCol,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Glowing upload icon circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2E1B4E),
                boxShadow: [
                  BoxShadow(
                    color: brandPurple.withValues(alpha: 0.35),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.cloud_upload_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 14),

            // Main Label
            Text(
              'Click to browse or drag & drop\nyour PDF resume here',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 6),

            // Constraint text
            Text(
              'Supports standard PDF format (Maximum file size: 10MB)',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
