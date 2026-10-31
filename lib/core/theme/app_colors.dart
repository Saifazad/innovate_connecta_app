import 'package:flutter/material.dart';

/// Nocturne Survey Design System - Color Palette & Scheme
class AppColors {
  AppColors._();

  // --- Material 3 Nocturne Survey Palette ---
  static const Color surface = Color(0xFF0B1326);
  static const Color surfaceDim = Color(0xFF0B1326);
  static const Color surfaceBright = Color(0xFF31394D);
  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow = Color(0xFF131B2E);
  static const Color surfaceContainer = Color(0xFF171F33);
  static const Color surfaceContainerHigh = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFCBC3D7);
  static const Color inverseSurface = Color(0xFFDAE2FD);
  static const Color inverseOnSurface = Color(0xFF283044);
  static const Color outline = Color(0xFF958EA0);
  static const Color outlineVariant = Color(0xFF494454);
  static const Color surfaceTint = Color(0xFFD0BCFF);

  static const Color primary = Color(0xFFD0BCFF);
  static const Color onPrimary = Color(0xFF3C0091);
  static const Color primaryContainer = Color(0xFFA078FF);
  static const Color onPrimaryContainer = Color(0xFF340080);
  static const Color inversePrimary = Color(0xFF6D3BD7);

  static const Color secondary = Color(0xFFC0C1FF);
  static const Color onSecondary = Color(0xFF1000A9);
  static const Color secondaryContainer = Color(0xFF3131C0);
  static const Color onSecondaryContainer = Color(0xFFB0B2FF);

  static const Color tertiary = Color(0xFFADC6FF);
  static const Color onTertiary = Color(0xFF002E6A);
  static const Color tertiaryContainer = Color(0xFF4D8EFF);
  static const Color onTertiaryContainer = Color(0xFF00285D);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color primaryFixed = Color(0xFFE9DDFF);
  static const Color primaryFixedDim = Color(0xFFD0BCFF);
  static const Color onPrimaryFixed = Color(0xFF23005C);
  static const Color onPrimaryFixedVariant = Color(0xFF5516BE);

  static const Color secondaryFixed = Color(0xFFE1E0FF);
  static const Color secondaryFixedDim = Color(0xFFC0C1FF);
  static const Color onSecondaryFixed = Color(0xFF07006C);
  static const Color onSecondaryFixedVariant = Color(0xFF2F2EBE);

  static const Color tertiaryFixed = Color(0xFFD8E2FF);
  static const Color tertiaryFixedDim = Color(0xFFADC6FF);
  static const Color onTertiaryFixed = Color(0xFF001A42);
  static const Color onTertiaryFixedVariant = Color(0xFF004395);

  static const Color surfaceVariant = Color(0xFF2D3449);

  // --- InnoVate Connecta Brand Identity Colors ---
  static const Color brandOrange = Color(0xFFF97316);
  static const Color brandNavy = Color(0xFF182467);
  static const Color brandPurple = Color(0xFFA855F7);
  static const Color brandAmber = Color(0xFFF59E0B);
  static const Color brandIndigo = Color(0xFF6366F1);
  static const Color brandCyan = Color(0xFF38BDF8);
  static const Color brandGreen = Color(0xFF10B981);
  static const Color darkCanvas = Color(0xFF090D16);
  static const Color cardBg = Color(0xFF101726);
  static const Color cardBorder = Color(0xFF1E293B);

  // --- Atmospheric Precision Semantic Accents ---
  static const Color canvasBase = Color(0xFF0A0F1D);
  static const Color cardSurface = Color(0xFF0F172A);
  static const Color surfaceRaised = Color(0xFF1E293B);
  static const Color surfaceInset = Color(0xFF080D19);

  static const Color primaryViolet = Color(0xFF8B5CF6);
  static const Color secondaryIndigo = Color(0xFF6366F1);
  static const Color tertiaryRoyalBlue = Color(0xFF3B82F6);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF475569);

  static const Color borderSubtle = Color(0xFF1E293B);
  static const Color borderActive = Color(0xFF8B5CF6);
  static const Color errorState = Color(0xFFF43F5E);

  static const Color cardActiveFill = Color(0xFF141F36);
  static const Color optionSelectedOverlay = Color(0x148B5CF6); // 8% opacity
  static const Color glowAmbient = Color(0x408B5CF6); // 25% opacity
  static const Color glowOutline = Color(0x4D8B5CF6); // 30% opacity

  /// Primary button diagonal gradient (Secondary Indigo to Primary Violet)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryIndigo, primaryViolet],
  );

  /// Progress bar gradient (Tertiary Royal Blue to Primary Violet)
  static const LinearGradient progressGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [tertiaryRoyalBlue, primaryViolet],
  );

  /// Material 3 ColorScheme builder for Nocturne dark mode
  static ColorScheme get darkColorScheme {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      inversePrimary: inversePrimary,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      surfaceDim: surfaceDim,
      surfaceBright: surfaceBright,
      surfaceContainerLowest: surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainer: surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      surfaceTint: surfaceTint,
    );
  }
}
