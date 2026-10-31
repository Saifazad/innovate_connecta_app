import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A stylized gradient button matching the signature purple/indigo accent styling.
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? leadingIcon;
  final Gradient? gradient;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color shadowColor;
  final double elevation;
  final Size? minimumSize;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.leadingIcon,
    this.gradient,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.borderRadius = 14,
    this.fontSize = 12.5,
    this.fontWeight = FontWeight.w700,
    this.textColor = Colors.white,
    this.shadowColor = const Color(0xFF7C3AED),
    this.elevation = 4,
    this.minimumSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ??
        const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.38),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: textColor,
          shadowColor: Colors.transparent,
          padding: padding,
          minimumSize: minimumSize ?? Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: fontSize + 2, color: textColor),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 5),
              Icon(icon, size: fontSize + 1.5, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
