import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandLogo extends StatelessWidget {
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final TextAlign textAlign;

  const BrandLogo({
    super.key,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w800,
    this.letterSpacing = -0.3,
    this.textAlign = TextAlign.start,
  });

  /// The official vibrant brand orange (#F97316)
  static const Color brandOrange = Color(0xFFF97316);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'InnoVate Connecta',
      child: RichText(
        textAlign: textAlign,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'InnoVate ',
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: Colors.white,
                letterSpacing: letterSpacing,
              ),
            ),
            TextSpan(
              text: 'Connecta',
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: brandOrange,
                letterSpacing: letterSpacing,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

