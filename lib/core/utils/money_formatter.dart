const String kCurrencySymbol = r'$';

/// Formats a monetary value with exactly 2 decimals and the currency prefix.
String formatAmount(double value) => '$kCurrencySymbol${value.toStringAsFixed(2)}';

/// Signed variant used by balance cards.
///
/// * settled (|value| < 0.005) → no sign, plain `$0.00`
/// * positive → `+$X.XX`
/// * negative → `−$X.XX` (Unicode minus U+2212 to match the HTML mock)
String formatSignedAmount(double value) {
  final bool settled = value.abs() < 0.005;
  final String prefix = settled ? '' : (value > 0 ? '+' : '−');
  return '$prefix$kCurrencySymbol${value.abs().toStringAsFixed(2)}';
}
