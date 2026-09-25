import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/form_section_title.dart';
import '../../invoices/domain/quebec_tax.dart' show centsToDollars;
import '../application/dashboard_providers.dart';

/// Home tab: money-in summaries (unpaid, paid this month, clients) plus
/// recent invoices. Values come from [dashboardSummaryProvider].
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final summary = ref.watch(dashboardSummaryProvider);
    final french = Localizations.localeOf(context).languageCode == 'fr';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navDashboard)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _SummaryCard(
            stats: [
              (
                label: l10n.dashboardUnpaid,
                value: formatCompactCurrency(
                  centsToDollars(summary.unpaidCents),
                  french: french,
                ),
              ),
              (
                label: l10n.dashboardPaidMonth,
                value: formatCompactCurrency(
                  centsToDollars(summary.paidThisMonthCents),
                  french: french,
                ),
              ),
              (
                label: l10n.dashboardClients,
                value: '${summary.clientCount}',
              ),
            ],
          ),
          FormSectionTitle(title: l10n.dashboardRecent),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Text(
              l10n.dashboardRecentEmpty,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stats});

  final List<({String label, String value})> stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      stats[i].value,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      stats[i].label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
