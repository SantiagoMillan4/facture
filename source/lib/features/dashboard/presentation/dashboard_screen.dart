import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/animated_money.dart';
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
            unpaid: centsToDollars(summary.unpaidCents),
            paidThisMonth: centsToDollars(summary.paidThisMonthCents),
            clientCount: summary.clientCount,
            french: french,
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
  const _SummaryCard({
    required this.unpaid,
    required this.paidThisMonth,
    required this.clientCount,
    required this.french,
  });

  final double unpaid;
  final double paidThisMonth;
  final int clientCount;
  final bool french;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final moneyStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: _Stat(
                label: l10n.dashboardUnpaid,
                child: AnimatedMoney(
                  value: unpaid,
                  format: (v) =>
                      formatCompactCurrency(v, french: french),
                  style: moneyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Stat(
                label: l10n.dashboardPaidMonth,
                child: AnimatedMoney(
                  value: paidThisMonth,
                  format: (v) =>
                      formatCompactCurrency(v, french: french),
                  style: moneyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Stat(
                label: l10n.dashboardClients,
                child: Text(
                  '$clientCount',
                  style: moneyStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        child,
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
