import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/animated_money.dart';
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
import '../application/dashboard_providers.dart';

/// Home tab: money-in summary, then the full invoice list with search and
/// status filters. Tapping an invoice opens its preview.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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

  bool _matches(Invoice invoice, Map<String, String> clientNames) {
    if (_statusFilter != null &&
        invoice.effectiveStatus != _statusFilter) {
      return false;
    }
    if (_query.isEmpty) return true;
    final clientName =
        (clientNames[invoice.clientId] ?? '').toLowerCase();
    return invoice.number.toLowerCase().contains(_query) ||
        clientName.contains(_query);
  }

  String _filterLabel(InvoiceStatus? status) {
    final l10n = context.l10n;
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
      appBar: AppBar(title: Text(l10n.navDashboard)),
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
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.sm,
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
              actionLabel: l10n.newInvoice,
              onAction: _openFormOrPaywall,
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
