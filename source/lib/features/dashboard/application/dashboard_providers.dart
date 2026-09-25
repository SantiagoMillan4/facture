import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/dashboard_summary.dart';

/// Dashboard totals.
///
/// TODO: derive from the invoice and client repositories once persistence
/// lands. Until then the stub is honest: no invoices means $0 unpaid.
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  return const DashboardSummary(
    unpaidCents: 0,
    paidThisMonthCents: 0,
    clientCount: 0,
  );
});
