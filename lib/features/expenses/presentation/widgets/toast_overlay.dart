import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/core/theme/app_radii.dart';
import 'package:splitly/core/theme/app_text_styles.dart';
import '../cubit/expenses_cubit.dart';
import '../cubit/expenses_state.dart';

class ToastOverlay extends StatefulWidget {
  const ToastOverlay({super.key});

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> {
  bool _visible = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPad = MediaQuery.paddingOf(context).bottom;
    return BlocListener<ExpensesCubit, ExpensesState>(
      listenWhen: (ExpensesState prev, ExpensesState next) =>
          prev.expenses.length < next.expenses.length,
      listener: (BuildContext context, ExpensesState state) {
        _timer?.cancel();
        setState(() => _visible = true);
        _timer = Timer(AppMotion.toastVisible, () {
          if (mounted) setState(() => _visible = false);
        });
      },
      child: Positioned(
        left: 0,
        right: 0,
        bottom: 96 + bottomPad,
        child: IgnorePointer(
          child: Center(
            child: AnimatedSlide(
              duration: AppMotion.toastFade,
              curve: Curves.easeOut,
              offset: _visible ? Offset.zero : const Offset(0, 0.4),
              child: AnimatedOpacity(
                duration: AppMotion.toastFade,
                opacity: _visible ? 1 : 0,
                child: Semantics(
                  label: 'Expense added',
                  liveRegion: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.foreground,
                      borderRadius: AppRadii.pillAll,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.toastShadow,
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Text('Expense added',
                        style: AppTextStyles.toast),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
