import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:splitly/core/constants/app_colors.dart';
import 'package:splitly/core/theme/app_motion.dart';
import 'package:splitly/features/expenses/presentation/pages/add_expense_page.dart';
import 'package:splitly/features/expenses/presentation/pages/expenses_list_page.dart';

class AppRoutes {
  static const String expenses = '/';
  static const String addExpense = '/add';

  static const String expensesName = 'expenses';
  static const String addExpenseName = 'addExpense';
}

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.expenses,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.expenses,
        name: AppRoutes.expensesName,
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _slidePage(
          state: state,
          child: const ExpensesListPage(),
          isRoot: true,
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'add',
            name: AppRoutes.addExpenseName,
            pageBuilder: (BuildContext context, GoRouterState state) =>
                _slidePage(
              state: state,
              child: const AddExpensePage(),
              isRoot: false,
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Route error: ${state.error}',
          style: const TextStyle(color: AppColors.foreground),
        ),
      ),
    ),
  );

  /// Builds a [CustomTransitionPage] where the incoming page slides from
  /// the right while the outgoing page shifts to `-22%` on X, reproducing
  /// the HTML mock's coordinated slide.
  static CustomTransitionPage<void> _slidePage({
    required GoRouterState state,
    required Widget child,
    required bool isRoot,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: AppMotion.pageSlide,
      reverseTransitionDuration: AppMotion.pageSlide,
      opaque: true,
      barrierColor: AppColors.background,
      child: child,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        final CurvedAnimation primary =
            CurvedAnimation(parent: animation, curve: AppMotion.slideCurve);
        final CurvedAnimation secondary = CurvedAnimation(
            parent: secondaryAnimation, curve: AppMotion.slideCurve);

        final Animation<Offset> incoming = isRoot
            ? const AlwaysStoppedAnimation<Offset>(Offset.zero)
            : Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(primary);

        final Animation<Offset> outgoing = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.22, 0),
        ).animate(secondary);

        return SlideTransition(
          position: outgoing,
          child: SlideTransition(position: incoming, child: child),
        );
      },
    );
  }
}
