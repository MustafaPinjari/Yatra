import 'package:flutter/material.dart';
import 'yatra_colors.dart';

/// YATRA Editorial & Transit Typography System
class YatraTypography {
  YatraTypography._();

  // High-contrast Editorial Display Serif (Playfair Display / Georgia)
  static TextStyle displayHeadline({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w700,
    Color color = YatraColors.inkPrimary,
    double height = 1.2,
  }) {
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontFamilyFallback: const ['Georgia', 'Cambria', 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: -0.5,
    );
  }

  // Large Stat / Metric Numerals
  static TextStyle metricSerif({
    double fontSize = 32,
    FontWeight fontWeight = FontWeight.w800,
    Color color = YatraColors.inkPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontFamilyFallback: const ['Georgia', 'Cambria', 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.1,
    );
  }

  // Section & Card Titles
  static TextStyle sectionTitle({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.w700,
    Color color = YatraColors.inkPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontFamilyFallback: const ['Georgia', 'Cambria', 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Modern Clean UI Body (Inter / Roboto)
  static TextStyle bodySans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = YatraColors.inkPrimary,
    double height = 1.4,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Roboto', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // Compact Uppercase Badges & Operational Tags
  static TextStyle labelCaps({
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w700,
    Color color = YatraColors.inkPrimary,
    double letterSpacing = 1.2,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Roboto', 'sans-serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
