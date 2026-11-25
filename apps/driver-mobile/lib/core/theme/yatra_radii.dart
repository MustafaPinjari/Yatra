import 'package:flutter/material.dart';

/// YATRA Consistent Border-Radius System
class YatraRadii {
  YatraRadii._();

  static const double sm = 8.0;
  static const double input = 12.0;
  static const double button = 12.0;
  static const double card = 16.0;
  static const double featureCard = 20.0;
  static const double hero = 24.0;
  static const double modal = 24.0;
  static const double iconContainer = 14.0;

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusInput = BorderRadius.all(Radius.circular(input));
  static const BorderRadius radiusButton = BorderRadius.all(Radius.circular(button));
  static const BorderRadius radiusCard = BorderRadius.all(Radius.circular(card));
  static const BorderRadius radiusFeatureCard = BorderRadius.all(Radius.circular(featureCard));
  static const BorderRadius radiusHero = BorderRadius.all(Radius.circular(hero));
  static const BorderRadius radiusIcon = BorderRadius.all(Radius.circular(iconContainer));
  static const BorderRadius radiusModal = BorderRadius.vertical(top: Radius.circular(modal));
}
