import 'package:flutter/painting.dart';

import '../constants/app_colors.dart';

/// Every text style used across the app lives here.
///
/// Widgets should never inline a [TextStyle] literal — pick the closest role
/// from this catalog. If a new style is truly one-off, add it here first so
/// the design system stays discoverable.
class AppTextStyles {
  AppTextStyles._();

  static const List<FontFeature> _tabularFigures = <FontFeature>[
    FontFeature.tabularFigures(),
  ];

  // ── Branding ─────────────────────────────────────────────────
  static const TextStyle logoTitle = TextStyle(
    color: AppColors.foreground,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.2,
  );

  static const TextStyle logoGlyph = TextStyle(
    color: AppColors.onAccent,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  // ── Section labels (uppercase) ───────────────────────────────
  static const TextStyle sectionLabel = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.4,
    height: 1.2,
  );

  static const TextStyle sectionLabelLoose = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.4,
    height: 1.2,
  );

  static const TextStyle formLabel = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    height: 1.2,
  );

  // ── Hero total amount ────────────────────────────────────────
  static const TextStyle heroAmount = TextStyle(
    color: AppColors.accent,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.1,
    fontFeatures: _tabularFigures,
  );

  static const TextStyle heroSummary = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 13,
    height: 1.2,
  );

  static const TextStyle countText = TextStyle(
    color: AppColors.foregroundFaint,
    fontSize: 12,
    height: 1.2,
    fontFeatures: _tabularFigures,
  );

  // ── Balance card ─────────────────────────────────────────────
  static const TextStyle balanceName = TextStyle(
    color: AppColors.foregroundMuted,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  /// Colour overridden per-status by the widget.
  static const TextStyle balanceAmount = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.15,
    fontFeatures: _tabularFigures,
  );

  static const TextStyle balanceSubtext = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 11,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // ── Expense tile ─────────────────────────────────────────────
  static const TextStyle tileInitials = TextStyle(
    color: AppColors.accent,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  static const TextStyle tileTitle = TextStyle(
    color: AppColors.foreground,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle tileSubtitle = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 12.5,
    height: 1.2,
  );

  static const TextStyle tileAmount = TextStyle(
    color: AppColors.foreground,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1,
    fontFeatures: _tabularFigures,
  );

  static const TextStyle tileRemove = TextStyle(
    color: AppColors.foregroundFaint,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  // ── Empty state ──────────────────────────────────────────────
  static const TextStyle emptyGlyph = TextStyle(
    color: AppColors.accent,
    fontSize: 30,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  static const TextStyle emptyTitle = TextStyle(
    color: AppColors.foreground,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle emptyBody = TextStyle(
    color: AppColors.foregroundDim,
    fontSize: 13.5,
    height: 1.45,
  );

  static const TextStyle emptyCta = TextStyle(
    color: AppColors.onAccent,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // ── Toast ────────────────────────────────────────────────────
  static const TextStyle toast = TextStyle(
    color: AppColors.onAccent,
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  // ── Splash ───────────────────────────────────────────────────
  static const TextStyle splashLogo = TextStyle(
    color: AppColors.accent,
    fontSize: 44,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  static const TextStyle splashTitle = TextStyle(
    color: AppColors.onAccent,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle splashSubtitle = TextStyle(
    color: AppColors.splashSubtitle,
    fontSize: 13.5,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
    height: 1.2,
  );

  // ── Form ─────────────────────────────────────────────────────
  static const TextStyle backGlyph = TextStyle(
    color: AppColors.foreground,
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1,
  );

  static const TextStyle formTitle = TextStyle(
    color: AppColors.foreground,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle nameFieldValue = TextStyle(
    color: AppColors.foreground,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  static const TextStyle nameFieldHint = TextStyle(
    color: AppColors.foregroundFaint,
    fontSize: 16,
    height: 1.2,
  );

  static const TextStyle amountFieldPrefix = TextStyle(
    color: AppColors.accent,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle amountFieldValue = TextStyle(
    color: AppColors.foreground,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
    fontFeatures: _tabularFigures,
  );

  static const TextStyle amountFieldHint = TextStyle(
    color: AppColors.foregroundFaint,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle payerChipInitial = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w700,
    height: 1,
  );

  static const TextStyle payerChipLabel = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle fieldError = TextStyle(
    color: AppColors.negative,
    fontSize: 12.5,
    height: 1.3,
  );

  static const TextStyle saveButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );
}
