import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../theme/app_radii.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
  Color? confirmColor,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext ctx) => _ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmColor: confirmColor,
    ),
  );
}

class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;

  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.outline),
          borderRadius: AppRadii.xlAll,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(title, style: AppTextStyles.formTitle),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: AppTextStyles.tileSubtitle),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                Expanded(child: _cancelButton(context)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _confirmButton(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cancelButton(BuildContext context) => Semantics(
        label: cancelLabel,
        button: true,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: AppRadii.pillAll,
            ),
            child: Semantics(
              excludeSemantics: true,
              child: Text(
                cancelLabel,
                style: const TextStyle(
                  color: AppColors.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _confirmButton(BuildContext context) => Semantics(
        label: confirmLabel,
        button: true,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(true),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: confirmColor ?? AppColors.accent,
              borderRadius: AppRadii.pillAll,
            ),
            child: Semantics(
              excludeSemantics: true,
              child: Text(
                confirmLabel,
                style: TextStyle(
                  color: confirmColor != null
                      ? AppColors.onAccent
                      : AppColors.onAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
}
