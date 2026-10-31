import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const ContactDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  static const Color fieldBg = Color(0xFF090E1A);
  static const Color fieldBorder = Color(0xFF1E293B);
  static const Color labelColor = Color(0xFF94A3B8);
  static const Color hintColor = Color(0xFF475569);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color focusPurple = Color(0xFFA855F7);
  static const Color dropdownBg = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: hasError ? errorRed : labelColor,
          ),
        ),
        const SizedBox(height: 6),

        // Dropdown Container
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasError ? errorRed : fieldBorder,
              width: 1.1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: hintColor,
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF94A3B8),
                size: 20,
              ),
              isExpanded: true,
              dropdownColor: dropdownBg,
              borderRadius: BorderRadius.circular(12),
              items: items.map((topic) {
                return DropdownMenuItem<String>(
                  value: topic,
                  child: Text(
                    topic,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),

        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: errorRed,
            ),
          ),
        ],
      ],
    );
  }
}
