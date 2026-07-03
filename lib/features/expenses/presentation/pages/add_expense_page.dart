import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/constants/people.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_spacing.dart';
import 'package:splitly/core/theme/app_text_styles.dart';
import 'package:splitly/core/utils/money_formatter.dart';
import 'package:splitly/core/widgets/confirm_dialog.dart';
import '../cubit/expenses_cubit.dart';
import '../widgets/payer_chip.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String? _selectedPerson;

  String? _nameError;
  String? _amountError;
  String? _payerError;

  bool _submitting = false;

  bool get _hasData =>
      _nameController.text.trim().isNotEmpty ||
      _amountController.text.trim().isNotEmpty ||
      _selectedPerson != null;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onPopInvokedWithResult(bool didPop, Object? result) async {
    if (didPop) return;
    if (_submitting) {
      if (context.mounted) context.pop();
      return;
    }
    if (_hasData) {
      final bool? shouldPop = await showConfirmDialog(
        context: context,
        title: 'Discard this expense?',
        message: 'You have unsaved data. Are you sure you want to go back?',
        confirmLabel: 'Discard',
        cancelLabel: 'Keep editing',
      );
      if (shouldPop == true && mounted) context.pop();
    } else {
      if (mounted) context.pop();
    }
  }

  void _submit() {
    if (_submitting) return;

    final String name = _nameController.text.trim();
    final String rawAmount = _amountController.text.trim();
    final double? amount = double.tryParse(rawAmount);

    String? nameError;
    String? amountError;
    String? payerError;

    if (name.isEmpty) nameError = 'Give this expense a name.';
    if (rawAmount.isEmpty || amount == null) {
      amountError = 'Enter an amount.';
    } else if (amount <= 0) {
      amountError = 'Amount must be greater than zero.';
    }
    if (_selectedPerson == null) payerError = 'Pick who paid.';

    if (nameError != null || amountError != null || payerError != null) {
      setState(() {
        _nameError = nameError;
        _amountError = amountError;
        _payerError = payerError;
      });
      return;
    }

    setState(() => _submitting = true);
    context.read<ExpensesCubit>().addExpense(
          name: name,
          amount: amount!,
          paidBy: _selectedPerson!,
        );
    context.pop();
  }

  void _clearNameError() {
    if (_nameError != null) setState(() => _nameError = null);
  }

  void _clearAmountError() {
    if (_amountError != null) setState(() => _amountError = null);
  }

  void _pickPayer(String name) {
    setState(() {
      _selectedPerson = name;
      _payerError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvokedWithResult,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              _FormHeader(onBack: () => context.pop()),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      AppSpacing.sm,
                      AppSpacing.xl,
                      AppSpacing.xl,
                    ),
                    children: <Widget>[
                      AppSpacing.vGapSm,
                      _NameField(
                        controller: _nameController,
                        error: _nameError,
                        onChanged: (_) => _clearNameError(),
                      ),
                      AppSpacing.vGapXl,
                      _AmountField(
                        controller: _amountController,
                        error: _amountError,
                        onChanged: (_) => _clearAmountError(),
                        onSubmitted: _submit,
                      ),
                      AppSpacing.vGapXl,
                      _PayerSection(
                        selected: _selectedPerson,
                        error: _payerError,
                        onPick: _pickPayer,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.xl,
                ),
                child: _SaveButton(
                  onTap: _submitting ? null : _submit,
                  isSubmitting: _submitting,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _FormHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _FormHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
      ),
      child: Row(
        children: <Widget>[
          Semantics(
            label: 'Back',
            button: true,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onBack,
              child: Container(
                padding: const EdgeInsets.all(5),
                child: Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.outline),
                    shape: BoxShape.circle,
                  ),
                  child: const Text('←', style: AppTextStyles.backGlyph),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text('New expense', style: AppTextStyles.formTitle),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) =>
      Text(label.toUpperCase(), style: AppTextStyles.formLabel);
}

class _FieldError extends StatelessWidget {
  final String text;
  const _FieldError(this.text);

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Text(text, style: AppTextStyles.fieldError),
      );
}

// ─────────────────────────────────────────────────────────────────
class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String> onChanged;

  const _NameField({
    required this.controller,
    required this.error,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color border =
        error != null ? AppColors.negative : AppColors.outlineStrong;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _FieldLabel('Expense name'),
        AppSpacing.vGapSm,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: border),
            borderRadius: AppRadii.lgAll,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: TextField(
            autofocus: true,
            controller: controller,
            onChanged: onChanged,
            style: AppTextStyles.nameFieldValue,
            cursorColor: AppColors.accent,
            decoration: const InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(vertical: 14),
              hintText: 'e.g. Groceries',
              hintStyle: AppTextStyles.nameFieldHint,
              border: InputBorder.none,
            ),
          ),
        ),
        if (error != null) ...<Widget>[
          AppSpacing.vGapSm,
          _FieldError(error!),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String> onChanged;
  final VoidCallback? onSubmitted;

  const _AmountField({
    required this.controller,
    required this.error,
    required this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final Color border =
        error != null ? AppColors.negative : AppColors.outlineStrong;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _FieldLabel('Amount'),
        AppSpacing.vGapSm,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: border),
            borderRadius: AppRadii.lgAll,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(kCurrencySymbol, style: AppTextStyles.amountFieldPrefix),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => onSubmitted?.call(),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  style: AppTextStyles.amountFieldValue,
                  cursorColor: AppColors.accent,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    hintText: '0.00',
                    hintStyle: AppTextStyles.amountFieldHint,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null) ...<Widget>[
          AppSpacing.vGapSm,
          _FieldError(error!),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _PayerSection extends StatelessWidget {
  final String? selected;
  final String? error;
  final ValueChanged<String> onPick;

  const _PayerSection({
    required this.selected,
    required this.error,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const _FieldLabel('Who paid?'),
        AppSpacing.vGapSm,
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.2,
          children: <Widget>[
            for (final String name in kPeople)
              PayerChip(
                name: name,
                selected: selected == name,
                onTap: () => onPick(name),
              ),
          ],
        ),
        if (error != null) ...<Widget>[
          AppSpacing.vGapSm,
          _FieldError(error!),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
class _SaveButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isSubmitting;
  const _SaveButton({required this.onTap, this.isSubmitting = false});

  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    final bool enabled = widget.onTap != null && !widget.isSubmitting;
    return Semantics(
      label: 'Save expense',
      button: true,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _scale = 0.98) : null,
        onTapCancel: enabled ? () => setState(() => _scale = 1) : null,
        onTapUp: enabled ? (_) => setState(() => _scale = 1) : null,
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _scale,
          duration: AppMotion.buttonPress,
          curve: Curves.easeOut,
          child: Container(
            height: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: enabled ? AppColors.accent : AppColors.surface,
              borderRadius: AppRadii.pillAll,
            ),
            child: widget.isSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.onAccent,
                    ),
                  )
                : Text(
                    'Save expense',
                    style: AppTextStyles.saveButton.copyWith(
                      color: enabled
                          ? AppColors.onAccent
                          : AppColors.foregroundFaint,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
