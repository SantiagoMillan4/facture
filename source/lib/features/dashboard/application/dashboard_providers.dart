import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../clients/application/clients_providers.dart';
import '../../invoices/application/invoices_providers.dart';
import '../../invoices/domain/invoice.dart';
import '../domain/dashboard_summary.dart';

/// Dashboard totals, derived from the on-device invoice book.
///
/// - unpaid: total of invoices not yet paid (draft, sent, overdue).
/// - paid this month: total of invoices with [Invoice.paidDate] in the
///   current month. With no invoices yet, both honestly read zero.
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final clientCount = ref.watch(clientsProvider).value?.length ?? 0;
  final invoices = ref.watch(invoicesProvider).value ?? [];

  final now = DateTime.now();
  var unpaidCents = 0;
  var paidThisMonthCents = 0;
  for (final invoice in invoices) {
    final totalCents = invoice.taxes().totalCents;
    if (invoice.status == InvoiceStatus.paid) {
      final paidDate = invoice.paidDate;
      if (paidDate != null &&
          paidDate.year == now.year &&
          paidDate.month == now.month) {
        paidThisMonthCents += totalCents;
      }
    } else {
      unpaidCents += totalCents;
    }
  }

  return DashboardSummary(
    unpaidCents: unpaidCents,
    paidThisMonthCents: paidThisMonthCents,
    clientCount: clientCount,
  );
});
