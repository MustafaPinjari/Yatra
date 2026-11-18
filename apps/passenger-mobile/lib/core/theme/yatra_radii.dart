import 'package:flutter/material.dart';

/// YATRA Consistent Border-Radius System
/// Standardized tokens for refined component geometry
class YatraRadii {
  YatraRadii._();

  // Geometric Dimensions
  static const double sm = 8.0; // Small controls, pills, status tags
  static const double input = 12.0; // Form inputs, search fields
  static const double button = 12.0; // Interactive buttons
  static const double card = 16.0; // Standard content cards
  static const double featureCard = 20.0; // Prominent feature cards & highlight tiles
  static const double hero = 24.0; // Hero display panels & map canvas containers
  static const double modal = 24.0; // Bottom sheets, action modals, dialogs
  static const double iconContainer = 14.0; // Rounded icon badges

  // Standardized BorderRadius Objects
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusInput = BorderRadius.all(Radius.circular(input));
  static const BorderRadius radiusButton = BorderRadius.all(Radius.circular(button));
  static const BorderRadius radiusCard = BorderRadius.all(Radius.circular(card));
  static const BorderRadius radiusFeatureCard = BorderRadius.all(Radius.circular(featureCard));
  static const BorderRadius radiusHero = BorderRadius.all(Radius.circular(hero));
  static const BorderRadius radiusIcon = BorderRadius.all(Radius.circular(iconContainer));
  static const BorderRadius radiusModal = BorderRadius.vertical(top: Radius.circular(modal));
}

