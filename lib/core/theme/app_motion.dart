import 'package:flutter/animation.dart';

/// Curves and durations shared by every animated widget.
///
/// [slideCurve] is the cubic-bezier used across the HTML mock for page and
/// element transitions.
class AppMotion {
  AppMotion._();

  static const Cubic slideCurve = Cubic(0.32, 0.72, 0, 1);

  // Page-level (list ↔ form)
  static const Duration pageSlide = Duration(milliseconds: 380);

  // Chip / interactive tokens
  static const Duration chipMorph = Duration(milliseconds: 150);
  static const Duration buttonPress = Duration(milliseconds: 150);

  // Toast (fade + slide)
  static const Duration toastFade = Duration(milliseconds: 300);
  static const Duration toastVisible = Duration(milliseconds: 2200);

  // Row-in animation for expense tiles
  static const Duration rowIn = Duration(milliseconds: 350);

  // Splash overlay lifecycle
  static const Duration splashPop = Duration(milliseconds: 700);
  static const Duration splashTextIn = Duration(milliseconds: 600);
  static const Duration splashTextDelay = Duration(milliseconds: 250);
  static const Duration splashFade = Duration(milliseconds: 500);
  static const Duration splashVisible = Duration(milliseconds: 1600);
  static const Duration splashRemove = Duration(milliseconds: 2200);
}
