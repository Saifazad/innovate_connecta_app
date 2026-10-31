import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Nocturne Survey Design System - Spacing Constants
class AppSpacing {
  AppSpacing._();

  static const double gutter = 16.0;
  static const double margin = 16.0;
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 28.0;
}

/// Nocturne Survey Design System - Border Radii
class AppRadius {
  AppRadius._();

  static const double sm = 4.0;
  static const double input = 8.0;
  static const double checkbox = 6.0;
  static const double card = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;

  static const BorderRadius smBorderRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(input));
  static const BorderRadius checkboxBorderRadius = BorderRadius.all(Radius.circular(checkbox));
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(card));
  static const BorderRadius fullBorderRadius = BorderRadius.all(Radius.circular(full));
}

/// Nocturne Survey Design System - Shadows & Glows
class AppShadows {
  AppShadows._();

  /// Level 2 Active card purple halo glow
  static const List<BoxShadow> activeCardGlow = [
    BoxShadow(
      color: AppColors.glowAmbient,
      blurRadius: 16,
      spreadRadius: -2,
      offset: Offset(0, 0),
    ),
  ];

  /// Level 3 Sticky bottom bar & sheet shadow
  static const List<BoxShadow> stickyBarShadow = [
    BoxShadow(
      color: Color(0x99000000), // 60% opacity black
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, -8),
    ),
  ];
}

/// Nocturne Survey Main Theme Configuration
class AppTheme {
  AppTheme._();

  /// Dark Theme Implementation adhering to the Nocturne Survey specifications
  static ThemeData get darkTheme {
    final colorScheme = AppColors.darkColorScheme;
    final textTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.canvasBase,
      canvasColor: AppColors.canvasBase,

      // --- Typography ---
      textTheme: textTheme,

      // --- AppBar Theme ---
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.canvasBase,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineSmall,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // --- Card Theme (Resting State) ---
      cardTheme: const CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.margin,
          vertical: AppSpacing.spaceSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.card)),
          side: BorderSide(color: AppColors.borderSubtle, width: 1.0),
        ),
      ),

      // --- Input Decoration Theme ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceInset,
        hintStyle: AppTypography.inputPlaceholder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spaceMd,
          vertical: AppSpacing.spaceSm * 1.5,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.input)),
          borderSide: BorderSide(color: AppColors.borderSubtle, width: 1.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.input)),
          borderSide: BorderSide(color: AppColors.borderSubtle, width: 1.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.input)),
          borderSide: BorderSide(color: AppColors.borderActive, width: 2.0),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.input)),
          borderSide: BorderSide(color: AppColors.errorState, width: 1.0),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.input)),
          borderSide: BorderSide(color: AppColors.errorState, width: 2.0),
        ),
      ),

      // --- Elevated Button Theme (Primary Action) ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryIndigo,
          foregroundColor: Colors.white,
          textStyle: AppTypography.buttonLabel,
          elevation: 0,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMd,
            vertical: AppSpacing.spaceSm * 1.5,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.full)),
          ),
        ),
      ),

      // --- Text Button Theme (Secondary / Ghost Action) ---
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: AppTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spaceMd,
            vertical: AppSpacing.spaceSm,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.input)),
          ),
        ),
      ),

      // --- Radio Button Theme ---
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryViolet;
          }
          return const Color(0xFF334155);
        }),
      ),

      // --- Checkbox Theme ---
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.checkbox),
        ),
        side: const BorderSide(color: Color(0xFF334155), width: 2.0),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primaryViolet;
          }
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
      ),

      // --- Chip Theme (Scale Rating / Option Chips) ---
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardSurface,
        disabledColor: AppColors.surfaceInset,
        selectedColor: AppColors.primaryViolet,
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        secondaryLabelStyle: AppTypography.bodyMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.borderSubtle, width: 1.0),
        ),
      ),

      // --- Progress Indicator Theme ---
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryViolet,
        linearTrackColor: AppColors.borderSubtle,
        linearMinHeight: 4.0,
      ),

      // --- Divider Theme ---
      dividerTheme: const DividerThemeData(
        color: AppColors.borderSubtle,
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
