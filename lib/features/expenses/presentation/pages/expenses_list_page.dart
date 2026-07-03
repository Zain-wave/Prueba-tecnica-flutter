import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:splitly/config/routes/app_router.dart';
import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_spacing.dart';
import 'package:splitly/core/theme/app_text_styles.dart';
import 'package:splitly/core/utils/money_formatter.dart';
import '../cubit/expenses_cubit.dart';
import '../cubit/expenses_state.dart';
import '../widgets/balance_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_tile.dart';
import '../widgets/toast_overlay.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/person_balance.dart';

class ExpensesListPage extends StatelessWidget {
  const ExpensesListPage({super.key});

  void _openForm(BuildContext context) =>
      context.pushNamed(AppRoutes.addExpenseName);

  @override
  Widget build(BuildContext context) {
    final double bottomPad = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: BlocBuilder<ExpensesCubit, ExpensesState>(
              buildWhen: (ExpensesState prev, ExpensesState next) =>
                  prev.expenses != next.expenses,
              builder: (BuildContext context, ExpensesState state) {
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: _Header(state: state)),
                    SliverToBoxAdapter(
                        child: _BalanceGrid(balances: state.balances)),
                    if (state.hasExpenses) ...<Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xl,
                          18,
                          AppSpacing.xl,
                          AppSpacing.md,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: _ExpensesSectionHeader(state: state),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.xl,
                          0,
                          AppSpacing.xl,
                          96 + bottomPad,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final Expense e =
                                  state.expensesNewestFirst[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSpacing.md),
                                child: _FadeInUp(
                                  key: ValueKey<String>('row-${e.id}'),
                                  child: ExpenseTile(
                                    expense: e,
                                    onRemove: () => context
                                        .read<ExpensesCubit>()
                                        .removeExpense(e.id),
                                  ),
                                ),
                              );
                            },
                            childCount: state.expenses.length,
                          ),
                        ),
                      ),
                    ] else
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyState(onAdd: () => _openForm(context)),
                      ),
                  ],
                );
              },
            ),
          ),
          const ToastOverlay(),
          Positioned(
            right: 20,
            bottom: 22 + bottomPad,
            child: Semantics(
              label: 'Add expense',
              button: true,
              child: _Fab(onTap: () => _openForm(context)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Header (logo + total hero)
// ─────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final ExpensesState state;

  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        18,
        AppSpacing.xl,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: AppRadii.smAll,
                ),
                child: const Text('÷', style: AppTextStyles.logoGlyph),
              ),
              AppSpacing.hGapMd,
              const Text('Splitly', style: AppTextStyles.logoTitle),
            ],
          ),
          const SizedBox(height: 16),
          const Text('TOTAL SPENT', style: AppTextStyles.sectionLabelLoose),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child:
                Text(formatAmount(state.total), style: AppTextStyles.heroAmount),
          ),
          const SizedBox(height: 2),
          Text(state.summaryText, style: AppTextStyles.heroSummary),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Balance grid — responsive columns + aspect ratio
// ─────────────────────────────────────────────────────────────────
class _BalanceGrid extends StatelessWidget {
  final List<PersonBalance> balances;

  const _BalanceGrid({required this.balances});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, 4),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.3),
          ),
        ),
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            final double width = constraints.maxWidth;
            final int crossAxisCount = width > 560 ? 4 : 2;
            return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: _aspectRatio(width),
            children: <Widget>[
              for (final PersonBalance b in balances) BalanceCard(data: b),
            ],
          );
        },
      ),
      ),
    );
  }

  static double _aspectRatio(double width) {
    if (width < 360) return 2.8;
    if (width < 560) return 2.4;
    if (width < 900) return 3.0;
    return 3.5;
  }
}

// ─────────────────────────────────────────────────────────────────
// Expenses section header (label + count)
// ─────────────────────────────────────────────────────────────────
class _ExpensesSectionHeader extends StatelessWidget {
  final ExpensesState state;

  const _ExpensesSectionHeader({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        const Text('EXPENSES', style: AppTextStyles.sectionLabel),
        const Spacer(),
        Text(state.countText, style: AppTextStyles.countText),
      ],
    );
  }
}

class _FadeInUp extends StatelessWidget {
  final Widget child;
  const _FadeInUp({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: AppMotion.rowIn,
      curve: Curves.easeOutCubic,
      builder: (BuildContext context, double value, Widget? child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// Floating action button (custom — rounded 18, not circular)
// ─────────────────────────────────────────────────────────────────
class _Fab extends StatefulWidget {
  final VoidCallback onTap;

  const _Fab({required this.onTap});

  @override
  State<_Fab> createState() => _FabState();
}

class _FabState extends State<_Fab> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapCancel: () => setState(() => _scale = 1),
      onTapUp: (_) => setState(() => _scale = 1),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: AppMotion.buttonPress,
        curve: Curves.easeOut,
        child: Container(
          width: 56,
          height: 56,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            borderRadius: AppRadii.xxlAll,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.fabShadow,
                blurRadius: 28,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Text(
            '+',
            style: TextStyle(
              color: AppColors.onAccent,
              fontSize: 28,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
