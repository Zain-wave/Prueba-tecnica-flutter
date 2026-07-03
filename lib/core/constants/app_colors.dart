import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds & surfaces
  static const Color background = Color(0xFF121210);
  static const Color surface = Color(0xFF1B1B17);
  static const Color surfaceHigh = Color(0xFF24241D);
  static const Color outline = Color(0xFF26261F);
  static const Color outlineStrong = Color(0xFF2A2A22);
  static const Color emptyDash = Color(0xFF3A3A2F);

  // Accent
  static const Color accent = Color(0xFFFFD43A);
  static const Color accentHover = Color(0xFFFFDE66);
  static const Color onAccent = Color(0xFF131309);
  static const Color accentTint = Color(0x24FFD43A); // rgba(255,212,58,0.14)
  static const Color accentTintOnAccent = Color(0x27131309); // rgba(19,19,9,0.15)

  // Foreground text
  static const Color foreground = Color(0xFFF2F0E6);
  static const Color foregroundMuted = Color(0xFFCFCDBE);
  static const Color foregroundDim = Color(0xFF8E8C7F);
  static const Color foregroundFaint = Color(0xFF7B796D);
  static const Color foregroundFainter = Color(0xFF5C5A50);

  // Semantic
  static const Color positive = Color(0xFF5FD79A);
  static const Color negative = Color(0xFFF07A6A);

  // Shadows
  static const Color fabShadow = Color(0x47FFD43A); // rgba(255,212,58,0.28)
  static const Color formShadow = Color(0x73000000); // rgba(0,0,0,0.45)
  static const Color toastShadow = Color(0x66000000); // rgba(0,0,0,0.4)

  // Splash overlay text
  static const Color splashSubtitle = Color(0xA6131309); // rgba(19,19,9,0.65)
}
