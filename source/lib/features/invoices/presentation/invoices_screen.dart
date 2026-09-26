import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/adaptive_action_sheet.dart';
import '../../../shared/widgets/adaptive_date_field.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../../../shared/widgets/swipe_to_delete_tile.dart';
import '../domain/quebec_tax.dart';
import '../../clients/application/clients_providers.dart';
import '../application/invoices_providers.dart';
import '../domain/invoice.dart';
import '../../purchase/application/purchase_providers.dart';
import '../../purchase/presentation/paywall_sheet.dart';
import 'invoice_form_screen.dart';
import 'invoice_preview_screen.dart';

/// Invoice list — the app's main feature tab. Newest first, swipe to
/// delete with confirmation, tap to preview.
class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  void _openForm(BuildContext context, [Invoice? invoice]) {
    pushAppPage(context, (_) => InvoiceFormScreen(invoice: invoice));
  }

  void _openPreview(BuildContext context, Invoice invoice) {
    pushAppPage(context, (_) => InvoicePreviewScreen(invoiceId: invoice.id));
  }

  /// Opens the invoice form, or the paywall once the free tier is used up.
  void _openFormOrPaywall(BuildContext context, WidgetRef ref) {
    if (ref.read(canCreateInvoiceProvider)) {
      _openForm(context);
    } else {
      showPaywallSheet(context);
    }
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
              onAction: () => _openFormOrPaywall(context, ref),
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
              return StaggeredEntrance(
                index: index,
                child: _InvoiceTile(
                  invoice: invoice,
                  onTap: () => _openPreview(context, invoice),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormOrPaywall(context, ref),
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

  /// Label + icon for each status the invoice may move to.
  ActionSheetOption<InvoiceStatus> _transitionOption(
    AppLocalizations l10n,
    InvoiceStatus status,
  ) {
    switch (status) {
      case InvoiceStatus.draft:
        return ActionSheetOption(
          value: status,
          label: l10n.invoiceBackToDraft,
          icon: Icons.drafts_outlined,
        );
      case InvoiceStatus.sent:
        return ActionSheetOption(
          value: status,
          label: invoice.status == InvoiceStatus.paid
              ? l10n.invoiceReopenAsSent
              : l10n.invoiceMarkSent,
          icon: Icons.send_outlined,
        );
      case InvoiceStatus.paid:
        return ActionSheetOption(
          value: status,
          label: l10n.invoiceMarkPaid,
          icon: Icons.check_circle_outline,
        );
      case InvoiceStatus.overdue:
        // Overdue is derived, never a transition target.
        return ActionSheetOption(value: status, label: '');
    }
  }

  /// Opens the status action sheet for the invoice's allowed transitions.
  Future<void> _changeStatus(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final targets = Invoice.allowedTransitions(invoice.effectiveStatus);
    final selected = await showAdaptiveActionSheet<InvoiceStatus>(
      context,
      title: l10n.invoiceChangeStatus,
      message: invoice.number.isEmpty ? null : invoice.number,
      options: [for (final s in targets) _transitionOption(l10n, s)],
    );
    if (selected == null || !context.mounted) return;
    AppHaptics.confirm();
    await ref.read(invoicesProvider.notifier).setStatus(invoice.id, selected);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final client =
        ref.watch(clientsProvider).value?.where((c) => c.id == invoice.clientId).firstOrNull;
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
            GestureDetector(
              onTap: () => _changeStatus(context, ref),
              child: Container(
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
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            Text(client?.name ?? '—'),
            Text(
              invoice.status == InvoiceStatus.paid && invoice.paidDate != null
                  ? l10n.invoicePaidOn(
                      formatShortDate(context, invoice.paidDate!),
                    )
                  : l10n.invoiceDueOn(formatShortDate(context, invoice.dueDate)),
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
