/// Money formatting standard for the whole app UI (whole dollars, no cents):
///
/// * Under $10,000: full whole dollars with thousands separators:
///   $925, $5,104, $1,400, $4,546.
/// * $10,000 and up: abbreviated with one decimal, trimming a dead `.0`:
///   $61.3k, $231k, $60k, $1.3M.
///
/// Rounding is half away from zero; -$0 never renders (shows $0).
/// Presentation-only: never affects stored/calculated financial values.
/// Pass `signed: true` for deltas so gains read `+$5,104`.
/// Pass `french: true` for Québec French placement: the symbol moves after
/// the amount with a narrow no-break space before it, thousands group with a
/// space, and decimals use a comma: `100 $`, `9 999 $`, `61,3 k$`.
String formatCompactCurrency(
  double amount, {
  bool signed = false,
  bool french = false,
}) {
  final rounded = amount.round();
  final absValue = rounded.abs();
  if (french) {
    final sign = rounded < 0
        ? '-'
        : signed && rounded > 0
        ? '+'
        : '';
    return '$sign${_compactMagnitudeFr(absValue)}';
  }
  final prefix = rounded < 0
      ? '-\$'
      : signed && rounded > 0
      ? '+\$'
      : '\$';
  return '$prefix${_compactMagnitude(absValue)}';
}

String _compactMagnitude(int absValue) {
  if (absValue >= 1000000) return '${_trimOne(absValue / 1000000)}M';
  if (absValue >= 10000) {
    final k = (absValue / 100).round() / 10;
    if (k >= 1000) return '${_trimOne(absValue / 1000000)}M';
    return '${_trimOne(k)}k';
  }
  return _groupThousands(absValue);
}

/// Narrow no-break space (U+202F): Québec French puts it before the `$`.
const _nbsp = ' ';

/// French variant of [_compactMagnitude]: `100 $`, `9 999 $`, `61,3 k$`,
/// `1,3 M$`. Narrow no-break space before the symbol, space thousands
/// separator, comma decimals.
String _compactMagnitudeFr(int absValue) {
  if (absValue >= 1000000) return '${_trimOneFr(absValue / 1000000)} M\$';
  if (absValue >= 10000) {
    final k = (absValue / 100).round() / 10;
    if (k >= 1000) return '${_trimOneFr(absValue / 1000000)} M\$';
    return '${_trimOneFr(k)} k\$';
  }
  return '${_groupThousandsFr(absValue)}$_nbsp\$';
}

/// One decimal with a comma, trimming a dead `,0`: 61.25 -> '61,3'.
String _trimOneFr(double value) {
  return _trimOne(value).replaceAll('.', ',');
}

/// One decimal, trimming a dead `.0`: 61.25 -> '61.3', 231.0 -> '231'.
String _trimOne(double value) {
  final rounded = (value * 10).round() / 10;
  if (rounded == rounded.roundToDouble()) return rounded.toInt().toString();
  return rounded.toStringAsFixed(1);
}

/// Full whole-dollar formatting with thousands separators, no abbreviation:
/// $5,104, $1,000,000, -$417. For tooltips and other exact-figure spots.
/// Presentation-only; pass `signed: true` for deltas (`+$5,104`).
/// Pass `french: true` for Québec French: `5 104 $`, `-417 $`.
String formatFullCurrency(
  double amount, {
  bool signed = false,
  bool french = false,
}) {
  final rounded = amount.round();
  final absValue = rounded.abs();
  if (french) {
    final sign = rounded < 0
        ? '-'
        : signed && rounded > 0
        ? '+'
        : '';
    return '$sign${_groupThousandsFr(absValue)}$_nbsp\$';
  }
  final sign = rounded < 0
      ? '-'
      : signed && rounded > 0
      ? '+'
      : '';
  return '$sign\$${_groupThousands(absValue)}';
}

/// Cents-keeping variant, used ONLY by the tax summary export (CRA T776
/// wants cents). Presentation-only. French: `1 234,56 $`.
String formatCurrencyWithCents(
  double amount, {
  bool signed = false,
  bool french = false,
}) {
  final negative = amount < 0;
  final cents = (amount.abs() * 100).round();
  final dollars = cents ~/ 100;
  final remainder = (cents % 100).toString().padLeft(2, '0');
  final sign = negative ? '-' : (signed && amount > 0 ? '+' : '');
  if (french) {
    return '$sign${_groupThousandsFr(dollars)},$remainder$_nbsp\$';
  }
  return '$sign\$${_groupThousands(dollars)}.$remainder';
}

String _groupThousands(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Space-separated thousands for Québec French: 1234567 -> '1 234 567'.
String _groupThousandsFr(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Trims insignificant trailing zeros, capped at [decimals] places:
/// 5.0 -> '5', 23.10 -> '23.1', 4.64 -> '4.64'. Half away from zero;
/// -0 never renders. Used for form-field prefills, NOT for rendered
/// percentages (those always show 2 decimals via [formatPercent]).
String formatDecimal(double value, {int decimals = 2}) {
  var factor = 1;
  for (var i = 0; i < decimals; i++) {
    factor *= 10;
  }
  final scaled = (value * factor).round();
  final abs = scaled.abs();
  final whole = abs ~/ factor;
  final frac = (abs % factor)
      .toString()
      .padLeft(decimals, '0')
      .replaceAll(RegExp(r'0+$'), '');
  final sign = scaled < 0 ? '-' : '';
  return frac.isEmpty ? '$sign$whole' : '$sign$whole.$frac';
}

/// Percentages always render with exactly 2 decimals: 23.10%, 76.90%, 4.64%.
/// Small rate differences matter in mortgage math, so trailing zeros are
/// significant. [value] is in percent units (4.64, not 0.0464).
/// -0.00 never renders.
String formatPercent(double value) {
  final text = value.toStringAsFixed(2);
  return '${text == '-0.00' ? '0.00' : text}%';
}

/// Parses a user-typed amount to integer cents.
///
/// Lenient on purpose: accepts `115.47` and `115,47` (French decimal
/// comma), ignores spaces and `$`. Unparseable input is 0, never an
/// exception — form fields re-validate separately.
int parseAmountToCents(String text) {
  final cleaned = text
      .replaceAll(' ', '')
      .replaceAll('\u00a0', '')
      .replaceAll('\u202f', '')
      .replaceAll('\$', '')
      .replaceAll(',', '.');
  final value = double.tryParse(cleaned);
  if (value == null || value.isNaN) return 0;
  final clamped = value.clamp(0, 999999999).toDouble();
  return (clamped * 100).round();
}

/// Parses a user-typed quantity (allows decimals, e.g. 2.5 hours).
double parseQuantity(String text) {
  final cleaned = text.replaceAll(' ', '').replaceAll(',', '.');
  final value = double.tryParse(cleaned);
  if (value == null || value.isNaN) return 0;
  return value.clamp(0, 999999).toDouble();
}
