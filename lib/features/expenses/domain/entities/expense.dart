import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String name;
  final double amount;
  final String paidBy;

  const Expense({
    required this.id,
    required this.name,
    required this.amount,
    required this.paidBy,
  });

  @override
  List<Object?> get props => <Object?>[id, name, amount, paidBy];
}
