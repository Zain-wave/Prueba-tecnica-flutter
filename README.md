# Split Expenses

Flutter application that tracks shared expenses among a fixed group of four
people and shows how much each of them should pay or receive relative to the
group average.

Built as the solution to the **Prueba Técnica de Flutter** (Ejercicio práctico
de desarrollo).

## Requirements covered

- List of expenses showing name, amount, and who paid.
- Form to register a new expense (name, amount, payer picked from a fixed list
  of four people).
- Balance per person calculated as `paid_by_person − group_average`, refreshed
  automatically after every new entry.
- Form validation: non-empty name, numeric amount strictly greater than zero,
  payer must be selected.
- Navigation between screens via `go_router` (`/` list, `/add` form as
  sub-route to preserve the back stack).
- State management with Cubit (`flutter_bloc`).

## Tech stack

| Concern           | Choice                                         |
| ----------------- | ---------------------------------------------- |
| Architecture      | Clean Architecture, feature-first              |
| State management  | Cubit (`flutter_bloc`)                         |
| Routing           | `go_router`                                    |
| Value equality    | `equatable`                                    |
| Theming           | Material 3, deep-purple seed, respects system  |
| Currency format   | Custom `formatAmount` helper (`COP $` prefix)  |

## Project structure

```
lib/
├── main.dart
├── config/
│   ├── routes/app_router.dart
│   └── theme/app_theme.dart
├── core/
│   ├── constants/people.dart       # kPeople (4 fixed names)
│   └── utils/money_formatter.dart  # formatAmount / kCurrencySymbol
└── features/
    └── expenses/
        ├── domain/entities/expense.dart
        └── presentation/
            ├── cubit/               # ExpensesCubit + ExpensesState
            ├── pages/               # ExpensesListPage, AddExpensePage
            └── widgets/             # ExpenseTile, BalanceTile, EmptyState
```

## Running the app

```bash
flutter pub get
flutter run              # any connected device
flutter run -d linux     # desktop
flutter run -d chrome    # web
```

Verify code health:

```bash
flutter analyze
```

## How it works

- `ExpensesCubit` owns the single source of truth: a `List<Expense>` inside
  `ExpensesState`.
- `total`, `average` and `balances` are **derived getters** on the state, so
  they are always in sync with the underlying list. Every time a new expense
  is added, `emit` produces a new state and every `BlocBuilder` in the tree
  rebuilds automatically — no manual refresh, no coupling between screens.
- The `AddExpensePage` uses a `Form` with per-field validators plus an
  `inputFormatter` that only accepts digits and up to two decimal places.
- The `ExpensesListPage` renders three sections in a single `CustomScrollView`:
  a summary card, the list of expenses, and the per-person balances. When the
  list is empty, an `EmptyState` widget takes over with a CTA that routes to
  `/add`, so the user never sees a blank screen.

## Reflection

Elegí Cubit por el alcance acotado: una entidad (Expense), una acción (addExpense) y balances derivados. BLoC agregaba boilerplate sin beneficio; Riverpod requería reestructurar main.dart. Cubit resuelve con menos código y encaja en presentation/. Los balances son getters en ExpensesState, no campos — la lista de gastos es la única fuente de verdad, se recalculan solos en cada BlocBuilder. Colores y moneda son concerns de los widgets, y todo monto pasa por formatAmount para 2 decimales consistentes.
