import 'package:flutter/material.dart';

/// A sleek glassmorphic back button container matching the dark app theme.
class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const AppBackButton({
    super.key,
    this.onTap,
    this.size = 40,
    this.iconSize = 17,
    this.borderRadius = 12,
    this.backgroundColor = const Color(0xFF131B2E),
    this.borderColor = const Color(0xFF1E293B),
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 1.1),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: iconSize,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
