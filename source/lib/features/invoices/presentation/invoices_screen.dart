import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../application/invoices_providers.dart';
import '../domain/invoice.dart';
import '../../purchase/application/purchase_providers.dart';
import '../../purchase/presentation/paywall_sheet.dart';
import 'invoice_form_screen.dart';
import 'invoice_list_tile.dart';
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
                child: InvoiceListTile(
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

