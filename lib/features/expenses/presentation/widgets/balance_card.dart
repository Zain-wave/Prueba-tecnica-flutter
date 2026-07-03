import 'package:flutter/material.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_spacing.dart';
import 'package:splitly/core/theme/app_text_styles.dart';
import 'package:splitly/core/utils/money_formatter.dart';
import '../../domain/entities/person_balance.dart';

class BalanceCard extends StatelessWidget {
  final PersonBalance data;

  const BalanceCard({super.key, required this.data});

  Color get _amountColor {
    switch (data.status) {
      case BalanceStatus.settled:
        return AppColors.foregroundDim;
      case BalanceStatus.receives:
        return AppColors.positive;
      case BalanceStatus.owes:
        return AppColors.negative;
    }
  }

  String get _subText {
    switch (data.status) {
      case BalanceStatus.settled:
        return 'SETTLED UP';
      case BalanceStatus.receives:
        return 'GETS BACK';
      case BalanceStatus.owes:
        return 'OWES';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String statusLabel;
    switch (data.status) {
      case BalanceStatus.settled:
        statusLabel = 'is settled';
      case BalanceStatus.receives:
        statusLabel = 'gets back';
      case BalanceStatus.owes:
        statusLabel = 'owes';
    }
    return Semantics(
      label: '${data.name} $statusLabel ${formatSignedAmount(data.amount)}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.outline),
          borderRadius: AppRadii.xlAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Semantics(
                  excludeSemantics: true,
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.accentTint,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      data.initials,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: Text(
                    data.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.balanceName,
                  ),
                ),
              ],
            ),
            AppSpacing.vGapSm,
            Text(
              formatSignedAmount(data.amount),
              style:
                  AppTextStyles.balanceAmount.copyWith(color: _amountColor),
            ),
            const SizedBox(height: 1),
            Text(_subText, style: AppTextStyles.balanceSubtext),
          ],
        ),
      ),
    );
  }
}
