import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Unified info tile widget for InnoVate Connecta.
/// Supports both compact inline chips (as in About) and full interactive cards with
/// clipboard copying (as in Contact).
class AppInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Color iconColor;
  final Color? iconBgColor;
  final Color? iconBorderColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool isCard;

  const AppInfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.value,
    this.iconColor = Colors.white,
    this.iconBgColor,
    this.iconBorderColor,
    this.textColor = Colors.white,
    this.onTap,
    this.isCard = false,
  });

  /// Factory constructor for compact inline metadata (e.g. in About hero)
  const factory AppInfoTile.compact({
    Key? key,
    required IconData icon,
    required String label,
    Color iconColor,
    Color textColor,
  }) = _CompactAppInfoTile;

  /// Factory constructor for interactive card tile (e.g. in Contact info section)
  const factory AppInfoTile.card({
    Key? key,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    required Color iconBgColor,
    required Color iconBorderColor,
    VoidCallback? onTap,
  }) = _CardAppInfoTile;

  static const Color tileBg = Color(0xFF101726);
  static const Color tileBorder = Color(0xFF1E293B);
  static const Color labelMuted = Color(0xFF94A3B8);

  void _copyToClipboard(BuildContext context) {
    if (value != null && value!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: value!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label copied to clipboard!'),
          backgroundColor: const Color(0xFF1E293B),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isCard) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 13,
                color: iconColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor ?? Colors.white,
              letterSpacing: -0.1,
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onTap ?? () => _copyToClipboard(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: tileBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tileBorder, width: 1.1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBgColor ?? const Color(0xFF131B2E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: iconBorderColor ?? const Color(0xFF1E293B),
                  width: 1.0,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: labelMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.copy_rounded,
              color: Color(0xFF475569),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactAppInfoTile extends AppInfoTile {
  const _CompactAppInfoTile({
    super.key,
    required super.icon,
    required super.label,
    super.iconColor = Colors.white,
    super.textColor = Colors.white,
  }) : super(isCard: false);
}

class _CardAppInfoTile extends AppInfoTile {
  const _CardAppInfoTile({
    super.key,
    required super.icon,
    required super.label,
    required String super.value,
    required super.iconColor,
    required Color super.iconBgColor,
    required Color super.iconBorderColor,
    super.onTap,
  }) : super(isCard: true);
}

