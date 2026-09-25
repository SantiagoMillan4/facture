import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../clients/application/clients_providers.dart';
import '../domain/dashboard_summary.dart';

/// Dashboard totals.
///
/// Unpaid / paid-this-month stay at honest zero until invoice persistence
/// lands; the client count is already real, derived from the on-device
/// client directory.
final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  final clientCount = ref.watch(clientsProvider).valueOrNull?.length ?? 0;
  return DashboardSummary(
    unpaidCents: 0,
    paidThisMonthCents: 0,
    clientCount: clientCount,
  );
});
