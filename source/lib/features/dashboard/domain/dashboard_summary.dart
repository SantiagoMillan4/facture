/// Totals shown on the dashboard.
///
/// Always derived from invoices and clients — never stored. With no
/// invoices yet, every total is truthfully zero.
class DashboardSummary {
  const DashboardSummary({
    required this.unpaidCents,
    required this.paidThisMonthCents,
    required this.clientCount,
  });

  /// Sum of sent/overdue invoice totals (incl. taxes), in cents.
  final int unpaidCents;

  /// Sum of invoices paid in the current calendar month, in cents.
  final int paidThisMonthCents;

  /// Number of clients in the directory.
  final int clientCount;
}
