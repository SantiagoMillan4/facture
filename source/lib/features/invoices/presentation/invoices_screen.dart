import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/animated_money.dart';
import '../../../shared/widgets/big_add_button.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../../clients/application/clients_providers.dart';
import '../../clients/domain/client.dart';
import '../../invoices/application/invoices_providers.dart';
import '../../invoices/domain/invoice.dart';
import '../../invoices/domain/quebec_tax.dart' show centsToDollars;
import '../../invoices/presentation/invoice_form_screen.dart';
import '../../invoices/presentation/invoice_list_tile.dart';
import '../../invoices/presentation/invoice_preview_screen.dart';
import '../../purchase/application/purchase_providers.dart';
import '../../purchase/presentation/paywall_sheet.dart';
import '../../dashboard/application/dashboard_providers.dart';

/// Invoices tab: money-in summary, a "needs attention" strip for overdue
/// and due-soon invoices, then the full invoice list with search and status
/// filters. Tapping an invoice opens its preview.
class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  /// Null means "all statuses".
  InvoiceStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    if (query != _query) setState(() => _query = query);
  }

  void _openPreview(Invoice invoice) {
    pushAppPage(
        context, (_) => InvoicePreviewScreen(invoiceId: invoice.id));
  }

  /// Opens the invoice form, or the paywall once the free tier is used up.
  void _openFormOrPaywall() {
    if (ref.read(canCreateInvoiceProvider)) {
      pushAppPage(context, (_) => const InvoiceFormScreen());
    } else {
      showPaywallSheet(context);
    }
  }

  /// Invoices that need chasing, most urgent first: overdue invoices, then
  /// sent invoices due within the next 7 days. Positive [daysOverdue]
  /// means overdue; zero or negative means due today / in -days.
  List<({Invoice invoice, int daysOverdue})> _attentionItems(
      List<Invoice> invoices) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final items = <({Invoice invoice, int daysOverdue})>[];
    for (final invoice in invoices) {
      final due = DateTime(
          invoice.dueDate.year, invoice.dueDate.month, invoice.dueDate.day);
      switch (invoice.effectiveStatus) {
        case InvoiceStatus.overdue:
          items.add(
              (invoice: invoice, daysOverdue: today.difference(due).inDays));
        case InvoiceStatus.sent:
          final daysUntil = due.difference(today).inDays;
          if (daysUntil <= 7) {
            items.add((invoice: invoice, daysOverdue: -daysUntil));
          }
        case InvoiceStatus.draft:
        case InvoiceStatus.paid:
          break;
      }
    }
    items.sort((a, b) => b.daysOverdue.compareTo(a.daysOverdue));
    return items;
  }

  bool _matches(Invoice invoice, Map<String, String> clientNames) {    if (_statusFilter != null &&
        invoice.effectiveStatus != _statusFilter) {
      return false;
    }
    if (_query.isEmpty) return true;
    final clientName =
        (clientNames[invoice.clientId] ?? '').toLowerCase();
    return invoice.number.toLowerCase().contains(_query) ||
        clientName.contains(_query);
  }

  String _filterLabel(InvoiceStatus? status) {    final l10n = context.l10n;
    switch (status) {
      case null:
        return l10n.dashboardFilterAll;
      case InvoiceStatus.draft:
        return l10n.statusDraft;
      case InvoiceStatus.sent:
        return l10n.statusSent;
      case InvoiceStatus.paid:
        return l10n.statusPaid;
      case InvoiceStatus.overdue:
        return l10n.statusOverdue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final summary = ref.watch(dashboardSummaryProvider);
    final invoicesAsync = ref.watch(invoicesProvider);
    final Map<String, String> clientNames = {
      for (final c in ref.watch(clientsProvider).value ?? <Client>[]) c.id: c.name,
    };
    final french = context.isFrench;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navInvoices)),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (invoices) {
          final visible = invoices
              .where((invoice) => _matches(invoice, clientNames))
              .toList()
            ..sort((a, b) => b.issueDate.compareTo(a.issueDate));
          final attention = _attentionItems(visible);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: BigAddButton(
                  key: const ValueKey('addInvoiceButton'),
                  label: l10n.newInvoice,
                  onPressed: _openFormOrPaywall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: _SummaryCard(
                  unpaid: centsToDollars(summary.unpaidCents),
                  paidThisMonth: centsToDollars(summary.paidThisMonthCents),
                  clientCount: summary.clientCount,
                  french: french,
                ),
              ),
              // The attention strip only makes sense unfiltered: with a
              // search or status filter active, the list below already
              // shows exactly those invoices.
              if (attention.isNotEmpty &&
                  _query.isEmpty &&
                  _statusFilter == null)
                _AttentionSection(
                  items: attention,
                  clientNames: clientNames,
                  french: french,
                  onTap: _openPreview,
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.xs,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.dashboardSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: l10n.clientsSearchClear,
                            icon: const Icon(Icons.clear),
                            onPressed: _searchController.clear,
                          ),
                    border: const OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(28)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.xs,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    for (final status in <InvoiceStatus?>[
                      null,
                      ...InvoiceStatus.values,
                    ])
                      Padding(
                        padding:
                            const EdgeInsets.only(right: AppSpacing.xs),
                        child: FilterChip(
                          label: Text(_filterLabel(status)),
                          selected: _statusFilter == status,
                          onSelected: (_) =>
                              setState(() => _statusFilter = status),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: _buildList(context, visible,
                    hasAnyInvoices: invoices.isNotEmpty),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<Invoice> visible, {
    required bool hasAnyInvoices,
  }) {
    final l10n = context.l10n;
    if (visible.isEmpty) {
      return hasAnyInvoices
          ? EmptyState(
              icon: Icons.search_off,
              title: l10n.dashboardNoResultsTitle,
              message: l10n.dashboardNoResultsMessage,
            )
          : EmptyState(
              icon: Icons.receipt_long_outlined,
              title: l10n.invoicesEmptyTitle,
              message: l10n.invoicesEmptySubtitle,
            );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      itemCount: visible.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final invoice = visible[index];
        return StaggeredEntrance(
          index: index,
          child: InvoiceListTile(
            invoice: invoice,
            onTap: () => _openPreview(invoice),
          ),
        );
      },
    );
  }
}

/// "Needs attention" strip: overdue invoices and sent invoices due within
/// 7 days, most urgent first. Hidden when there is nothing to chase.
/// Tapping a row opens the invoice preview.
class _AttentionSection extends StatelessWidget {
  const _AttentionSection({
    required this.items,
    required this.clientNames,
    required this.french,
    required this.onTap,
  });

  final List<({Invoice invoice, int daysOverdue})> items;
  final Map<String, String> clientNames;
  final bool french;
  final void Function(Invoice invoice) onTap;

  String _urgencyLabel(BuildContext context, int daysOverdue) {
    final l10n = context.l10n;
    if (daysOverdue > 0) return l10n.dashboardOverdueBy(daysOverdue);
    if (daysOverdue == 0) return l10n.dashboardDueToday;
    return l10n.dashboardDueIn(-daysOverdue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: theme.colorScheme.error,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                l10n.dashboardAttentionTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final item in items)
            _AttentionRow(
              invoice: item.invoice,
              clientName: clientNames[item.invoice.clientId],
              urgency: _urgencyLabel(context, item.daysOverdue),
              overdue: item.daysOverdue > 0,
              french: french,
              onTap: () => onTap(item.invoice),
            ),
        ],
      ),
    );
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({
    required this.invoice,
    required this.clientName,
    required this.urgency,
    required this.overdue,
    required this.french,
    required this.onTap,
  });

  final Invoice invoice;
  final String? clientName;
  final String urgency;
  final bool overdue;
  final bool french;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        overdue ? theme.colorScheme.error : theme.colorScheme.primary;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        dense: true,
        leading: Icon(
          overdue ? Icons.error_outline : Icons.schedule,
          color: color,
        ),
        title: Text(
          invoice.number.isEmpty ? '—' : invoice.number,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          clientName == null ? urgency : '$clientName • $urgency',
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          formatCurrencyWithCents(
              centsToDollars(invoice.taxes().totalCents),
              french: french),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        onTap: onTap,
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
      margin: EdgeInsets.zero,
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
