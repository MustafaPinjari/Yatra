import 'package:flutter/material.dart';
import 'yatra_colors.dart';
import 'yatra_radii.dart';

/// High-contrast theme tailored for Delhi bus driver cab consoles
class YatraDriverTheme {
  YatraDriverTheme._();

  static ThemeData get cabTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: YatraColors.navyDarkest,
      colorScheme: const ColorScheme.dark(
        primary: YatraColors.terracotta,
        onPrimary: Colors.white,
        secondary: YatraColors.heritageGreen,
        onSecondary: Colors.white,
        surface: Color(0xFF101B3A),
        onSurface: Colors.white,
        error: YatraColors.errorRed,
        onError: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF101B3A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'Playfair Display',
          fontFamilyFallback: ['Georgia', 'serif'],
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF141F36),
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: YatraRadii.radiusCard,
          side: BorderSide(color: Color(0xFF233554), width: 1.2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: YatraColors.terracotta,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: const RoundedRectangleBorder(
            borderRadius: YatraRadii.radiusButton,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
