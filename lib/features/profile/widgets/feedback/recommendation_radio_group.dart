import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendationRadioGroup extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String> onChanged;

  const RecommendationRadioGroup({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  static const List<String> options = [
    'Yes, Absolutely!',
    'Maybe',
    'Needs Improvement',
  ];

  static const Color brandPurple = Color(0xFFA855F7);
  static const Color textMuted = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Would you recommend InnoVate Connecta to peers?',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            fontWeight: FontWeight.w400,
            color: textMuted,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 16,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? brandPurple : const Color(0xFF475569),
                        width: 1.5,
                      ),
                      color: isSelected ? brandPurple : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(
                              Icons.circle,
                              size: 7,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
