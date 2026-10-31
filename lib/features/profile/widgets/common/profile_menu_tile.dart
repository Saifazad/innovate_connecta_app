import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDestructive ? const Color(0xFFF43F5E) : Colors.white;
    final chevronColor = isDestructive ? const Color(0xFFF43F5E) : const Color(0xFF64748B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Icon Box
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 14),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                ),

                // Chevron
                Icon(
                  Icons.chevron_right_rounded,
                  color: chevronColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(
            color: Color(0xFF1E293B),
            height: 1,
            indent: 14,
            endIndent: 14,
          ),
      ],
    );
  }
}
