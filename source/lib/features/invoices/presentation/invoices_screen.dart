import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/adaptive_date_field.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/swipe_to_delete_tile.dart';
import '../domain/quebec_tax.dart';
import '../../clients/application/clients_providers.dart';
import '../application/invoices_providers.dart';
import '../domain/invoice.dart';
import 'invoice_form_screen.dart';

/// Invoice list — the app's main feature tab. Newest first, swipe to
/// delete with confirmation, tap to edit.
class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  void _openForm(BuildContext context, [Invoice? invoice]) {
    pushAppPage(context, (_) => InvoiceFormScreen(invoice: invoice));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.invoicesTitle)),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (invoices) {
          if (invoices.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: l10n.invoicesEmptyTitle,
              message: l10n.invoicesEmptySubtitle,
              actionLabel: l10n.newInvoice,
              onAction: () => _openForm(context),
            );
          }
          final sorted = List<Invoice>.of(invoices)
            ..sort((a, b) => b.issueDate.compareTo(a.issueDate));
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: sorted.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final invoice = sorted[index];
              return _InvoiceTile(
                invoice: invoice,
                onTap: () => _openForm(context, invoice),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        tooltip: l10n.newInvoice,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _InvoiceTile extends ConsumerWidget {
  const _InvoiceTile({required this.invoice, required this.onTap});

  final Invoice invoice;
  final VoidCallback onTap;

  Color _statusColor(BuildContext context, InvoiceStatus status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case InvoiceStatus.draft:
        return scheme.onSurfaceVariant;
      case InvoiceStatus.sent:
        return scheme.primary;
      case InvoiceStatus.paid:
        return scheme.tertiary;
      case InvoiceStatus.overdue:
        return scheme.error;
    }
  }

  String _statusLabel(AppLocalizations l10n, InvoiceStatus status) {
    switch (status) {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final client =
        ref.watch(clientsProvider).valueOrNull?.where((c) => c.id == invoice.clientId).firstOrNull;
    final status = invoice.effectiveStatus;
    final total = invoice.taxes().totalCents;
    final french = context.isFrench;

    return SwipeToDeleteTile(
      onDelete: () =>
          ref.read(invoicesProvider.notifier).deleteInvoice(invoice.id),
      confirmDelete: true,
      deleteTitle: l10n.invoiceDeleteTitle,
      deleteMessage: l10n.invoiceDeleteMessage(invoice.number),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: Theme.of(context).colorScheme.surfaceContainerLow,
        title: Row(
          children: [
            Expanded(
              child: Text(
                invoice.number.isEmpty ? '—' : invoice.number,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: _statusColor(context, status).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                _statusLabel(l10n, status),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: _statusColor(context, status),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(client?.name ?? '—'),
            Text(
              l10n.invoiceDueOn(formatShortDate(context, invoice.dueDate)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Text(
          formatCurrencyWithCents(centsToDollars(total), french: french),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        onTap: onTap,
      ),
    );
  }
}
