import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// An animated category/filter pill chip with selected and unselected states.
class FilterTabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color activeColor;
  final Color inactiveBgColor;
  final Color inactiveBorderColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;

  const FilterTabChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.activeColor = const Color(0xFF7C3AED),
    this.inactiveBgColor = const Color(0xFF131B2E),
    this.inactiveBorderColor = const Color(0xFF1E293B),
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = const Color(0xFF94A3B8),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = 20,
    this.fontSize = 12.5,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected ? activeColor : inactiveBgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isSelected ? activeColor : inactiveBorderColor,
            width: 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? activeTextColor : inactiveTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
