import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Standard, reusable text form field for InnoVate Connecta.
/// Consolidates Auth and Contact text inputs with support for icons, password toggling,
/// validation, multiline input, and custom trailing header widgets.
class AppTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isRequired;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffixIcon;
  final Widget? headerTrailing;
  final String? Function(String?)? validator;
  final String? errorText;
  final int minLines;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const AppTextField({
    super.key,
    required this.label,
    this.hintText,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.isRequired = false,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.headerTrailing,
    this.validator,
    this.errorText,
    this.minLines = 1,
    this.maxLines = 1,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.contentPadding,
  });

  static const Color fieldBackground = Color(0xFF0F172A);
  static const Color fieldBorder = Color(0xFF1E293B);
  static const Color focusBorder = Color(0xFFA855F7);
  static const Color labelColor = Color(0xFFCBD5E1);
  static const Color hintColor = Color(0xFF475569);
  static const Color iconColor = Color(0xFF64748B);
  static const Color errorRed = Color(0xFFEF4444);

  String get _effectiveHint => hintText ?? hint ?? '';
  int get _effectiveMinLines => obscureText ? 1 : minLines;
  int get _effectiveMaxLines {
    if (obscureText) return 1;
    final min = _effectiveMinLines;
    return maxLines < min ? min : maxLines;
  }

  @override
  Widget build(BuildContext context) {
    final hasCustomError = errorText != null && errorText!.isNotEmpty;
    final trailing = headerTrailing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label Row with optional required asterisk '*' and trailing action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: hasCustomError ? errorRed : labelColor,
                ),
                children: [
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: GoogleFonts.inter(
                        color: errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
        const SizedBox(height: 7),

        // Text Form Field
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onFieldSubmitted: onFieldSubmitted,
          minLines: _effectiveMinLines,
          maxLines: _effectiveMaxLines,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: _effectiveHint,
            hintStyle: GoogleFonts.inter(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: hintColor,
            ),
            errorText: hasCustomError ? errorText : null,
            errorStyle: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: errorRed,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: iconColor, size: 19)
                : prefix,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fieldBackground,
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: fieldBorder, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: fieldBorder, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: focusBorder, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorRed, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: errorRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
