import 'package:flutter/material.dart';
import 'yatra_colors.dart';
import 'yatra_radii.dart';
import 'yatra_typography.dart';

/// Complete Material 3 Theme for YATRA Passenger Application
class YatraTheme {
  YatraTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: YatraColors.parchmentBg,
      colorScheme: const ColorScheme.light(
        primary: YatraColors.terracotta,
        onPrimary: Colors.white,
        secondary: YatraColors.navyDeep,
        onSecondary: Colors.white,
        surface: YatraColors.surfaceCream,
        onSurface: YatraColors.inkPrimary,
        error: YatraColors.errorRed,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: YatraColors.inkPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'Playfair Display',
          fontFamilyFallback: ['Georgia', 'serif'],
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: YatraColors.inkPrimary,
        ),
      ),
      cardTheme: const CardThemeData(
        color: YatraColors.surfaceCream,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: YatraRadii.radiusCard,
          side: BorderSide(color: YatraColors.softBorder, width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: YatraColors.terracotta,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50), // WCAG touch target
          shape: const RoundedRectangleBorder(
            borderRadius: YatraRadii.radiusButton,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: YatraColors.inkPrimary,
          minimumSize: const Size.fromHeight(48),
          side: const BorderSide(color: YatraColors.softBorder, width: 1.5),
          shape: const RoundedRectangleBorder(
            borderRadius: YatraRadii.radiusButton,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: YatraColors.surfaceCream,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: YatraRadii.radiusInput,
          borderSide: BorderSide(color: YatraColors.softBorder, width: 1.2),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: YatraRadii.radiusInput,
          borderSide: BorderSide(color: YatraColors.softBorder, width: 1.2),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: YatraRadii.radiusInput,
          borderSide: BorderSide(color: YatraColors.terracotta, width: 2),
        ),
        hintStyle: YatraTypography.bodySans(
          fontSize: 14,
          color: YatraColors.inkMuted,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: YatraColors.softBorder,
        thickness: 1,
        space: 24,
      ),
    );
  }
}
