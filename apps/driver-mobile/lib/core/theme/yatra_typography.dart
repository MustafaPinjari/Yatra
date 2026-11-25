import 'package:flutter/material.dart';
import 'yatra_colors.dart';

/// YATRA Typography System for Driver Cab Display
class YatraTypography {
  YatraTypography._();

  static TextStyle displayHeadline({
    double fontSize = 24,
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
      letterSpacing: -0.3,
    );
  }

  static TextStyle metricSerif({
    double fontSize = 28,
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

  static TextStyle sectionTitle({
    double fontSize = 16,
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

  static TextStyle bodySans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = YatraColors.inkSecondary,
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

  static TextStyle tabularMeta({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w600,
    Color color = YatraColors.inkPrimary,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontFamilyFallback: const ['Roboto', 'sans-serif'],
      fontFeatures: const [FontFeature.tabularFigures()],
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
