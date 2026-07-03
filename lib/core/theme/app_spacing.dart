import 'package:flutter/widgets.dart';

/// Vertical/horizontal spacing tokens used by every screen.
///
/// Values line up with the HTML mock's padding/gap system so every widget
/// pulls from the same scale instead of inlining magic numbers.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 14;
  static const double xl = 20;
  static const double xxl = 24;

  // Pre-baked SizedBox widgets for the common cases so widget trees stay
  // free of `const SizedBox(height: 10)` littering.
  static const Widget vGapXs = SizedBox(height: xs);
  static const Widget vGapSm = SizedBox(height: sm);
  static const Widget vGapMd = SizedBox(height: md);
  static const Widget vGapLg = SizedBox(height: lg);
  static const Widget vGapXl = SizedBox(height: xl);

  static const Widget hGapXs = SizedBox(width: xs);
  static const Widget hGapSm = SizedBox(width: sm);
  static const Widget hGapMd = SizedBox(width: md);
  static const Widget hGapLg = SizedBox(width: lg);
}
