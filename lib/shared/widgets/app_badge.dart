import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A versatile badge/pill component for displaying category tags,
/// status indicators, ratings, or media metadata with icons and glowing dots.
class AppBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final double iconSize;
  final bool showDot;
  final Color? dotColor;
  final double dotSize;
  final Color backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double? letterSpacing;
  final Widget? trailing;

  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.iconColor,
    this.iconSize = 12.5,
    this.showDot = false,
    this.dotColor,
    this.dotSize = 6,
    this.backgroundColor = const Color(0xFF131B2E),
    this.borderColor,
    this.borderWidth = 0.8,
    this.textColor = Colors.white,
    this.fontSize = 11,
    this.fontWeight = FontWeight.w600,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    this.borderRadius = 10,
    this.letterSpacing,
    this.trailing,
  });

  /// Category tag factory (with semi-transparent accent background and subtle border)
  factory AppBadge.category({
    Key? key,
    required String label,
    Color color = const Color(0xFFF97316),
    double fontSize = 11,
    bool uppercase = false,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    double borderRadius = 10,
  }) {
    return AppBadge(
      key: key,
      label: uppercase ? label.toUpperCase() : label,
      backgroundColor: color.withValues(alpha: 0.15),
      borderColor: color.withValues(alpha: 0.35),
      textColor: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.3,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// Status badge factory with optional circular dot indicator
  factory AppBadge.status({
    Key? key,
    required String label,
    required Color color,
    bool withDot = true,
    double fontSize = 10.5,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
    double borderRadius = 10,
  }) {
    return AppBadge(
      key: key,
      label: label,
      showDot: withDot,
      dotColor: color,
      backgroundColor: color.withValues(alpha: 0.16),
      borderColor: color.withValues(alpha: 0.38),
      textColor: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// Meta badge factory with an icon (e.g. duration, lessons, rating)
  factory AppBadge.meta({
    Key? key,
    required String label,
    required IconData icon,
    Color iconColor = const Color(0xFF94A3B8),
    Color textColor = const Color(0xFFE2E8F0),
    Color backgroundColor = const Color(0xFF0F172A),
    Color borderColor = const Color(0xFF334155),
    double fontSize = 11,
    double iconSize = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    double borderRadius = 10,
    Widget? trailing,
  }) {
    return AppBadge(
      key: key,
      label: label,
      icon: icon,
      iconColor: iconColor,
      iconSize: iconSize,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      textColor: textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      padding: padding,
      borderRadius: borderRadius,
      trailing: trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showDot) ...[
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor ?? textColor,
              ),
            ),
            const SizedBox(width: 5),
          ],
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize,
              color: iconColor ?? textColor,
            ),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
                letterSpacing: letterSpacing,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 4),
            trailing!,
          ],
        ],
      ),
    );
  }
}
