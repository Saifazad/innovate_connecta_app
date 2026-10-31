import 'package:flutter/material.dart';

/// Glowing circular play button with radiant gradient and shadow effects.
class GlowPlayButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final IconData icon;
  final List<Color> gradientColors;
  final Color glowColor;

  const GlowPlayButton({
    super.key,
    this.onTap,
    this.size = 48,
    this.iconSize = 26,
    this.icon = Icons.play_arrow_rounded,
    this.gradientColors = const [Color(0xFFA855F7), Color(0xFF7C3AED)],
    this.glowColor = const Color(0xFFA855F7),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.65),
              blurRadius: size * 0.38,
              spreadRadius: size > 44 ? 3 : 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
