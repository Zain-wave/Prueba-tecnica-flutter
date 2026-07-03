import 'package:equatable/equatable.dart';

import 'package:splitly/core/constants/people.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/person_balance.dart';

class ExpensesState extends Equatable {
  final List<Expense> expenses;

  const ExpensesState({
    this.expenses = const <Expense>[],
  });

  // ── derived getters ─────────────────────────────────────────────
  double get total =>
      expenses.fold<double>(0, (double sum, Expense e) => sum + e.amount);

  double get average =>
      expenses.isEmpty ? 0 : total / kPeople.length;

  bool get hasExpenses => expenses.isNotEmpty;
  bool get isEmpty => expenses.isEmpty;

  /// Human-readable summary line under the total.
  String get summaryText {
    if (expenses.isEmpty) return '4 friends · nothing shared yet';
    final String noun = expenses.length == 1 ? 'expense' : 'expenses';
    return '4 friends · ${expenses.length} $noun';
  }

  /// "Expenses" section counter ("3 items" / "1 item").
  String get countText {
    final String noun = expenses.length == 1 ? 'item' : 'items';
    return '${expenses.length} $noun';
  }

  /// Ordered by [kPeople] so the balance grid never reshuffles.
  List<PersonBalance> get balances {
    final double avg = average;
    return <PersonBalance>[
      for (final String person in kPeople)
        _computeBalance(person, avg),
    ];
  }

  PersonBalance _computeBalance(String person, double avg) {
    final double paid = expenses
        .where((Expense e) => e.paidBy == person)
        .fold<double>(0, (double s, Expense e) => s + e.amount);
    final double bal = paid - avg;
    final BalanceStatus status = bal.abs() < 0.005
        ? BalanceStatus.settled
        : bal > 0
            ? BalanceStatus.receives
            : BalanceStatus.owes;
    return PersonBalance(
      name: person,
      initials: person[0],
      amount: bal,
      status: status,
    );
  }

  /// Expenses rendered newest-first in the list section.
  List<Expense> get expensesNewestFirst =>
      expenses.reversed.toList(growable: false);

  ExpensesState copyWith({
    List<Expense>? expenses,
  }) =>
      ExpensesState(
        expenses: expenses ?? this.expenses,
      );

  @override
  List<Object?> get props => <Object?>[expenses];
}
