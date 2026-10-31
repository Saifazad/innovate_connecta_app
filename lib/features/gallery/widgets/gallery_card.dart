import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gallery_item.dart';

class GalleryCard extends StatelessWidget {
  final GalleryItem item;
  final VoidCallback? onTap;

  const GalleryCard({
    super.key,
    required this.item,
    this.onTap,
  });

  static const Color cardBorderColor = Color(0xFF1E293B);
  static const Color placeholderBg = Color(0xFF131B2E);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: cardBorderColor, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Image with loading and error states
              _buildImage(),

              // 2. Subtle Dark Vignette Gradients (top for badge contrast, bottom for text contrast)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.45),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.90),
                      ],
                      stops: const [0.0, 0.30, 0.60, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. Top Floating Category Badge
              Positioned(
                top: 10,
                left: 10,
                child: _buildBadge(),
              ),

              // 4. Bottom Title & Location
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.location != null && item.location!.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 11,
                            color: Color(0xFF94A3B8),
                          ),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(
                              item.location!,
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF94A3B8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4.5),
      decoration: BoxDecoration(
        color: item.badgeBgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: item.badgeBorderColor, width: 0.9),
      ),
      child: Text(
        item.categoryName,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: item.badgeTextColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (item.imageUrl.isEmpty) {
      return Container(
        color: placeholderBg,
        child: const Center(
          child: Icon(Icons.image_outlined, color: Color(0xFF475569), size: 36),
        ),
      );
    }

    return Image.network(
      item.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: placeholderBg,
          child: Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFFA855F7).withValues(alpha: 0.7),
                ),
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: placeholderBg,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.broken_image_outlined,
                  color: Color(0xFF64748B),
                  size: 32,
                ),
                const SizedBox(height: 6),
                Text(
                  item.categoryName,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
