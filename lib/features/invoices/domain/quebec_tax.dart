/// Québec sales-tax computation — STUB ONLY, not implemented yet.
///
/// Exact rules to implement (do not approximate; get them wrong and the
/// invoices the app produces are wrong):
///
/// - TPS (GST): 5% on the line subtotal.
/// - TVQ (QST): 9.975%, computed on the line subtotal INCLUDING TPS
///   (i.e. TVQ base = subtotal × 1.05). This is the Québec-specific rule
///   that generic invoicing tools get wrong — TVQ is a tax on a tax.
/// - Rounding: every tax amount is rounded to the nearest cent PER LINE,
///   then summed across lines. Never compute tax on the invoice total and
///   round once.
/// - Registration numbers: an invoice that charges TPS/TVQ must show the
///   supplier's TPS and TVQ registration numbers.
/// - Small-supplier rule: a freelancer with $30,000 or less of taxable
///   sales in the last four calendar quarters (plus the current quarter)
///   is not required to register and must NOT charge TPS/TVQ. The app must
///   let the user declare their registration status and switch taxes off
///   entirely — a "charge taxes" toggle is not a rounding detail, it is a
///   legal boundary.
///
/// Like financial definitions in Rentable, these rules are exact, covered
/// by unit tests, and never silently changed.
library;

/// TPS amount for one line's pre-tax [lineSubtotal].
double tpsForLine(double lineSubtotal) {
  throw UnimplementedError('quebec_tax: TPS computation not implemented yet');
}

/// TVQ amount for one line's pre-tax [lineSubtotal].
///
/// Note the Québec rule: the 9.975% applies to the subtotal INCLUDING TPS.
double tvqForLine(double lineSubtotal) {
  throw UnimplementedError('quebec_tax: TVQ computation not implemented yet');
}

/// Rounds [amount] to the nearest cent (half away from zero).
///
/// Applied per line, per tax, before summing — never once on the total.
double roundToCent(double amount) {
  throw UnimplementedError(
    'quebec_tax: per-line cent rounding not implemented yet',
  );
}

/// Full tax breakdown for an invoice's lines.
({double subtotal, double tps, double tvq, double total}) taxesForLines(
  List<double> lineSubtotals, {
  required bool taxesChargeable,
}) {
  throw UnimplementedError(
    'quebec_tax: invoice tax breakdown not implemented yet',
  );
}
