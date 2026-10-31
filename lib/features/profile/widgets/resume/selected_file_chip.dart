import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedFileChip extends StatelessWidget {
  final String fileName;
  final String fileSize;
  final VoidCallback onRemove;

  const SelectedFileChip({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.onRemove,
  });

  static const Color brandPurple = Color(0xFFA855F7);
  static const Color borderCol = Color(0xFF382B5F);
  static const Color greenVerified = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF171738),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderCol, width: 1.1),
      ),
      child: Row(
        children: [
          // File Icon Box
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF2E1B4E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: brandPurple.withValues(alpha: 0.4),
                width: 1.0,
              ),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: Color(0xFFC084FC),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  fileName,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: greenVerified,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$fileSize • Ready to upload',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: greenVerified,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Close / Remove Button
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xFF94A3B8),
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
