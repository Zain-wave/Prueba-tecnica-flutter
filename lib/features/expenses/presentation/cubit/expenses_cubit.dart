import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit({bool seed = true})
      : super(
          ExpensesState(expenses: seed ? _seedExpenses() : const <Expense>[]),
        );

  static List<Expense> _seedExpenses() => const <Expense>[
        Expense(
          id: 'seed-1',
          name: 'Groceries',
          amount: 64.5,
          paidBy: 'Sebastian',
        ),
        Expense(
          id: 'seed-2',
          name: 'Pizza night',
          amount: 38,
          paidBy: 'Veronica',
        ),
        Expense(
          id: 'seed-3',
          name: 'Ride to the beach',
          amount: 23.75,
          paidBy: 'Diego',
        ),
      ];

  void addExpense({
    required String name,
    required double amount,
    required String paidBy,
  }) {
    HapticFeedback.lightImpact();
    final double rounded = (amount * 100).round() / 100;
    final Expense expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name.trim(),
      amount: rounded,
      paidBy: paidBy,
    );
    emit(state.copyWith(
      expenses: <Expense>[...state.expenses, expense],
    ));
  }

  void removeExpense(String id) {
    HapticFeedback.lightImpact();
    emit(state.copyWith(
      expenses: state.expenses
          .where((Expense e) => e.id != id)
          .toList(growable: false),
    ));
  }
}
