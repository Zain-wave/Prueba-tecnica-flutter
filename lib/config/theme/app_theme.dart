import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:splitly/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  /// Space Grotesk with tabular figures — mirrors the HTML's
  /// `font-variant-numeric: tabular-nums` on hero and amount text.
  static TextTheme _textTheme(Brightness brightness) {
    final TextTheme base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    return GoogleFonts.spaceGroteskTextTheme(base).apply(
      bodyColor: AppColors.foreground,
      displayColor: AppColors.foreground,
    );
  }

  /// Single dark theme — the design has no light variant.
  static ThemeData get dark {
    final TextTheme textTheme = _textTheme(Brightness.dark);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        onPrimary: AppColors.onAccent,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        surface: AppColors.background,
        onSurface: AppColors.foreground,
        error: AppColors.negative,
        onError: AppColors.onAccent,
        outline: AppColors.outline,
      ),
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }

  /// The design ships only a dark variant; keep `light` as an alias so the
  /// existing `MaterialApp.themeMode` wiring keeps compiling.
  static ThemeData get light => dark;
}
