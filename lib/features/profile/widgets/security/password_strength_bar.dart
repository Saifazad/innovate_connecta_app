import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum PasswordStrengthLevel {
  empty(0, 'None', Color(0xFF64748B)),
  weak(1, 'Weak', Color(0xFFEF4444)),
  fair(2, 'Fair', Color(0xFFA855F7)),
  good(3, 'Good', Color(0xFF38BDF8)),
  strong(4, 'Strong', Color(0xFF10B981));

  final int score;
  final String label;
  final Color color;

  const PasswordStrengthLevel(this.score, this.label, this.color);
}

class PasswordStrengthBar extends StatelessWidget {
  final String password;

  const PasswordStrengthBar({super.key, required this.password});

  PasswordStrengthLevel get strength {
    if (password.isEmpty) return PasswordStrengthLevel.empty;
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password) || RegExp(r'[!@#\$&*~]').hasMatch(password)) score++;

    switch (score) {
      case 1:
        return PasswordStrengthLevel.weak;
      case 2:
        return PasswordStrengthLevel.fair;
      case 3:
        return PasswordStrengthLevel.good;
      case 4:
        return PasswordStrengthLevel.strong;
      default:
        return PasswordStrengthLevel.weak;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lvl = strength;
    final activeSegments = lvl.score;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password Strength',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF94A3B8),
              ),
            ),
            Text(
              lvl == PasswordStrengthLevel.empty ? '' : lvl.label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: lvl.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // 4 Segmented Bars
        Row(
          children: List.generate(4, (index) {
            final isFilled = index < activeSegments;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                decoration: BoxDecoration(
                  color: isFilled ? lvl.color : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
