import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_spacing.dart';
import 'package:splitly/core/theme/app_text_styles.dart';
import 'package:splitly/core/utils/money_formatter.dart';
import 'package:splitly/core/widgets/confirm_dialog.dart';
import '../../domain/entities/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onRemove;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.outline),
        borderRadius: AppRadii.xlAll,
      ),
      child: Row(
        children: <Widget>[
          Semantics(
            label:
                '${expense.name}, ${formatAmount(expense.amount)}, paid by ${expense.paidBy}',
            excludeSemantics: true,
            child: Row(
              children: <Widget>[
                Semantics(
                  label: expense.paidBy,
                  excludeSemantics: true,
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceHigh,
                      borderRadius: AppRadii.mdAll,
                    ),
                    child: Text(
                      expense.paidBy.characters.first,
                      style: AppTextStyles.tileInitials,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        expense.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.tileTitle,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Paid by ${expense.paidBy}',
                        style: AppTextStyles.tileSubtitle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  formatAmount(expense.amount),
                  style: AppTextStyles.tileAmount,
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final bool? confirmed = await showConfirmDialog(
                context: context,
                title: 'Remove expense?',
                message:
                    'Delete "${expense.name}" for ${formatAmount(expense.amount)}?',
                confirmLabel: 'Remove',
                cancelLabel: 'Cancel',
                confirmColor: AppColors.negative,
              );
              if (confirmed == true) {
                HapticFeedback.lightImpact();
                onRemove();
              }
            },
            child: Semantics(
              label: 'Remove ${expense.name}',
              button: true,
              excludeSemantics: true,
              child: Container(
                padding: const EdgeInsets.all(11),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 26,
                  height: 26,
                  child: Center(
                    child: Text('×', style: AppTextStyles.tileRemove),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
