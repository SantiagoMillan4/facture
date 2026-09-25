/// Québec sales-tax computation (TPS/TVQ) — exact integer-cent arithmetic.
///
/// The rules, exactly (an invoice is a legal document — get them wrong and
/// the invoices the app produces are wrong):
///
/// - TPS: 5% on the line subtotal.
/// - TVQ: 9.975%, computed on the line subtotal INCLUDING TPS
///   (TVQ base = subtotal + TPS). This is the Québec-specific rule that
///   generic invoicing tools get wrong — TVQ is a tax on a tax.
/// - Rounding: every tax amount is rounded to the nearest cent PER LINE,
///   then summed across lines. Never compute tax on the invoice total and
///   round once. Half-cents round away from zero, symmetrically for
///   negative (discount) lines.
/// - Registration numbers: an invoice charging TPS/TVQ must show the
///   supplier's TPS and TVQ registration numbers (presentation concern,
///   not computed here).
/// - Small-supplier rule: $30,000 or less of taxable sales in the last four
///   calendar quarters (plus the current quarter) → not required to
///   register and must NOT charge TPS/TVQ. Callers pass
///   `chargeTaxes: false` in that case; it is a legal boundary, not a
///   rounding detail.
///
/// All amounts are integer cents. Rates are stored as double percents but
/// converted to exact per-million integers, so 5% and 9.975% (up to 3
/// decimals) compute with zero floating-point error. Tax amounts are
/// always derived, never stored.
///
/// Like financial definitions in a cashflow tool, these rules are exact,
/// covered by unit tests, and never silently changed.
library;

/// TPS/TVQ rates as percentages. Defaults are the current Québec rates.
///
/// Rates are user-editable (a legal safeguard: the user, not the app, is
/// responsible for the rates on their invoices). Up to 3 decimals are
/// exact (e.g. 9.975); more decimals are rounded to 3.
class QuebecTaxRates {
  const QuebecTaxRates({this.tpsPercent = 5.0, this.tvqPercent = 9.975});

  /// TPS (GST) percent, e.g. 5.0.
  final double tpsPercent;

  /// TVQ (QST) percent, e.g. 9.975.
  final double tvqPercent;
}

/// Per-line tax breakdown, in integer cents.
class LineTaxes {
  const LineTaxes({
    required this.subtotalCents,
    required this.tpsCents,
    required this.tvqCents,
  });

  /// Pre-tax line subtotal (already rounded to the cent by the caller).
  final int subtotalCents;

  /// TPS on [subtotalCents], rounded to the cent.
  final int tpsCents;

  /// TVQ on ([subtotalCents] + [tpsCents]), rounded to the cent.
  final int tvqCents;

  /// Line total including taxes.
  int get totalCents => subtotalCents + tpsCents + tvqCents;
}

/// Invoice-level tax breakdown, in integer cents.
///
/// Every total is the sum of the per-line rounded amounts — taxes are
/// never computed on the invoice subtotal and rounded once.
class InvoiceTaxes {
  const InvoiceTaxes(this.lines);

  final List<LineTaxes> lines;

  int get subtotalCents =>
      lines.fold(0, (sum, line) => sum + line.subtotalCents);
  int get tpsCents => lines.fold(0, (sum, line) => sum + line.tpsCents);
  int get tvqCents => lines.fold(0, (sum, line) => sum + line.tvqCents);
  int get totalCents => lines.fold(0, (sum, line) => sum + line.totalCents);
}

/// Converts a dollar amount to integer cents, rounding half away from zero.
///
/// Inputs are expected at cent precision (e.g. 19.99); thousandths of a
/// cent and beyond are an input error, not a tax rule.
int dollarsToCents(double dollars) => (dollars * 100).round();

/// Converts integer cents back to dollars for display.
double centsToDollars(int cents) => cents / 100.0;

/// Tax on [baseCents] at [percent], rounded to the nearest cent, half away
/// from zero (symmetric for negative amounts, e.g. discount lines).
int _taxCents(int baseCents, double percent) {
  // Exact for rates with up to 3 decimals: 9.975 -> 99750 per million.
  final perMillion = (percent * 10000).round();
  if (perMillion <= 0 || baseCents == 0) return 0;
  const halfMillion = 500000;
  const million = 1000000;
  final product = baseCents * perMillion;
  // Shift by half a cent in the value's own direction, then truncate
  // toward zero: equivalent to round-half-away-from-zero.
  final adjusted = product >= 0 ? product + halfMillion : product - halfMillion;
  return adjusted ~/ million;
}

/// Tax breakdown for one pre-tax line subtotal (in cents).
///
/// Pass `chargeTaxes: false` for a small supplier (not registered): the
/// subtotal is preserved and every tax amount is zero.
LineTaxes taxesForLine(
  int subtotalCents, {
  QuebecTaxRates rates = const QuebecTaxRates(),
  bool chargeTaxes = true,
}) {
  if (!chargeTaxes) {
    return LineTaxes(subtotalCents: subtotalCents, tpsCents: 0, tvqCents: 0);
  }
  final tpsCents = _taxCents(subtotalCents, rates.tpsPercent);
  // Québec rule: TVQ applies to the subtotal INCLUDING TPS.
  final tvqCents = _taxCents(subtotalCents + tpsCents, rates.tvqPercent);
  return LineTaxes(
    subtotalCents: subtotalCents,
    tpsCents: tpsCents,
    tvqCents: tvqCents,
  );
}

/// Tax breakdown for an invoice's pre-tax line subtotals (in cents).
///
/// Each line is taxed and rounded independently, then summed — the Québec
/// per-line rounding rule. See [taxesForLine] for the [chargeTaxes]
/// small-supplier boundary.
InvoiceTaxes taxesForInvoice(
  Iterable<int> lineSubtotalsCents, {
  QuebecTaxRates rates = const QuebecTaxRates(),
  bool chargeTaxes = true,
}) {
  return InvoiceTaxes(
    lineSubtotalsCents
        .map(
          (subtotal) => taxesForLine(
            subtotal,
            rates: rates,
            chargeTaxes: chargeTaxes,
          ),
        )
        .toList(),
  );
}

/// Recovers the pre-tax subtotal from a tax-included total (in cents).
///
/// Inverts [taxesForLine]: finds the subtotal whose forward-computed total
/// equals [totalCents]. Because rounding makes the forward map stepwise,
/// the inverse is estimated arithmetically and then corrected by
/// re-checking forward (the map is strictly increasing — each extra
/// pre-tax cent adds at least one total cent — so the loop converges in
/// a step or two). Totals that fall in a rounding gap return the closest
/// achievable breakdown.
LineTaxes extractTaxes(
  int totalCents, {
  QuebecTaxRates rates = const QuebecTaxRates(),
}) {
  if (totalCents <= 0) {
    return LineTaxes(subtotalCents: totalCents, tpsCents: 0, tvqCents: 0);
  }
  // total ≈ subtotal * (1 + tps) * (1 + tvq): invert for a starting
  // estimate (double precision is plenty for an estimate; the loop below
  // makes the result exact).
  final combinedFactor =
      (1 + rates.tpsPercent / 100) * (1 + rates.tvqPercent / 100);
  var subtotal = (totalCents / combinedFactor).round();
  for (var i = 0; i < 10; i++) {
    final forward = taxesForLine(subtotal, rates: rates).totalCents;
    if (forward == totalCents) break;
    subtotal += forward < totalCents ? 1 : -1;
  }
  return taxesForLine(subtotal, rates: rates);
}
