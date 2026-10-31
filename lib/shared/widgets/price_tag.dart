import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A pricing display widget showing a highlighted current/discount price
/// alongside an optional strikethrough original price.
class PriceTag extends StatelessWidget {
  final String currentPrice;
  final String? originalPrice;
  final String? prefix;
  final Color currentPriceColor;
  final double currentPriceSize;
  final FontWeight currentPriceWeight;
  final Color originalPriceColor;
  final double originalPriceSize;
  final double spacing;
  final bool showStrikethrough;

  const PriceTag({
    super.key,
    String? currentPrice,
    String? fee,
    String? originalPrice,
    String? originalFee,
    this.prefix,
    Color? currentPriceColor,
    Color? accentColor,
    this.currentPriceSize = 18,
    this.currentPriceWeight = FontWeight.w800,
    this.originalPriceColor = const Color(0xFF64748B),
    this.originalPriceSize = 12.5,
    this.spacing = 8,
    this.showStrikethrough = true,
  })  : currentPrice = currentPrice ?? fee ?? '',
        originalPrice = originalPrice ?? originalFee,
        currentPriceColor = currentPriceColor ?? accentColor ?? const Color(0xFFFACC15);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (prefix != null && prefix!.isNotEmpty) ...[
          Text(
            prefix!,
            style: GoogleFonts.inter(
              fontSize: currentPriceSize * 0.7,
              fontWeight: FontWeight.w600,
              color: currentPriceColor,
            ),
          ),
          const SizedBox(width: 2),
        ],
        Text(
          currentPrice,
          style: GoogleFonts.inter(
            fontSize: currentPriceSize,
            fontWeight: currentPriceWeight,
            color: currentPriceColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (originalPrice != null && originalPrice!.isNotEmpty) ...[
          SizedBox(width: spacing),
          Flexible(
            child: Text(
              originalPrice!,
              style: GoogleFonts.inter(
                fontSize: originalPriceSize,
                fontWeight: FontWeight.w400,
                color: originalPriceColor,
                decoration: showStrikethrough ? TextDecoration.lineThrough : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
