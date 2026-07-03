import 'package:equatable/equatable.dart';

/// Presentation-agnostic view of a person's balance sheet.
///
/// The cubit builds this list off the raw expenses so widgets only render
/// values instead of running their own arithmetic.
enum BalanceStatus { settled, receives, owes }

class PersonBalance extends Equatable {
  final String name;
  final String initials;
  final double amount; // signed: positive → receives, negative → owes
  final BalanceStatus status;

  const PersonBalance({
    required this.name,
    required this.initials,
    required this.amount,
    required this.status,
  });

  @override
  List<Object?> get props => <Object?>[name, initials, amount, status];
}
