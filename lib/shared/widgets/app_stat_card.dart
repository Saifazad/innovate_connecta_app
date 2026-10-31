import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified Stat and Pillar Card for InnoVate Connecta.
/// Supports both metric-oriented column cards (Dashboard) and narrative pillar cards (About).
class AppStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String? value;
  final String? subtitle;
  final String? description;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isMetric;

  const AppStatCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.value,
    this.subtitle,
    this.description,
    this.trailing,
    this.onTap,
    this.isMetric = true,
  });

  /// Factory constructor for Dashboard numerical metric card
  const factory AppStatCard.metric({
    Key? key,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String subtitle,
    VoidCallback? onTap,
  }) = _MetricStatCard;

  /// Factory constructor for About feature pillar card
  const factory AppStatCard.pillar({
    Key? key,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    Widget? trailing,
    VoidCallback? onTap,
  }) = _PillarStatCard;

  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    if (isMetric) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cardBorder, width: 1.1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 17),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final trailingWidget = trailing;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder, width: 1.1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.05),
          highlightColor: Colors.white.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    ?trailingWidget,
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: textMuted,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricStatCard extends AppStatCard {
  const _MetricStatCard({
    super.key,
    required super.icon,
    required super.iconColor,
    required super.iconBgColor,
    required super.title,
    required String super.value,
    required String super.subtitle,
    super.onTap,
  }) : super(isMetric: true);
}

class _PillarStatCard extends AppStatCard {
  const _PillarStatCard({
    super.key,
    required super.icon,
    required super.iconColor,
    required super.iconBgColor,
    required super.title,
    required String super.description,
    super.trailing,
    super.onTap,
  }) : super(isMetric: false);
}
