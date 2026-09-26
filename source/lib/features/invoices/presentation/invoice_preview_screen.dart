import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../l10n/app_l10n.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../business/application/business_logo.dart';
import '../../business/application/business_profile_providers.dart';
import '../../business/domain/business_profile.dart';
import '../../clients/application/clients_providers.dart';
import '../../clients/domain/client.dart';
import '../application/invoices_providers.dart';
import '../domain/invoice.dart';
import '../pdf/invoice_pdf.dart';
import '../pdf/share_invoice_pdf.dart';
import 'invoice_form_screen.dart';

/// Full-screen preview of a saved invoice.
///
/// Shows the invoice exactly as the client will receive it, with the two
/// actions that matter at this point: share the PDF wherever the user
/// wants, or go back and edit it. Closing returns to the list.
///
/// The screen watches the invoice providers, so edits made through the form
/// refresh the preview automatically when returning to it.
class InvoicePreviewScreen extends ConsumerWidget {
  const InvoicePreviewScreen({super.key, required this.invoiceId});

  final String invoiceId;

  void _openEditor(BuildContext context, Invoice invoice) {
    pushAppPage(context, (_) => InvoiceFormScreen(invoice: invoice));
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final invoice = _findInvoice(ref);
    final client = _findClient(ref, invoice);
    if (invoice == null || client == null) return;
    await shareInvoicePdf(
      invoice: invoice,
      client: client,
      profile: ref.read(businessProfileProvider).value,
      l10n: context.l10n,
    );
  }

  Invoice? _findInvoice(WidgetRef ref) {
    final invoices = ref.read(invoicesProvider).value;
    if (invoices == null) return null;
    return invoices.where((i) => i.id == invoiceId).firstOrNull;
  }

  Client? _findClient(WidgetRef ref, Invoice? invoice) {
    if (invoice == null) return null;
    final clients = ref.read(clientsProvider).value;
    if (clients == null) return null;
    return clients.where((c) => c.id == invoice.clientId).firstOrNull;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final invoicesAsync = ref.watch(invoicesProvider);
    final clientsAsync = ref.watch(clientsProvider);
    final profileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_findInvoice(ref)?.number ?? l10n.invoicesTitle),
        actions: [
          IconButton(
            tooltip: l10n.invoicePreviewEdit,
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              final invoice = _findInvoice(ref);
              if (invoice != null) _openEditor(context, invoice);
            },
          ),
        ],
      ),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (_) => clientsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (_) => profileAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(error.toString())),
            data: (profile) => _buildPreview(context, ref, l10n, profile),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    BusinessProfile? profile,
  ) {
    final invoice = _findInvoice(ref);
    final client = _findClient(ref, invoice);
    if (invoice == null || client == null) {
      return Center(child: Text(l10n.invoicePreviewNotFound));
    }
    final french = context.isFrench;
    return Column(
      children: [
        Expanded(
          child: PdfPreview(
            build: (format) async {
              final logoBytes = await BusinessLogo.readBytes(profile?.logoPath);
              return buildInvoicePdf(
                invoice: invoice,
                client: client,
                profile: profile,
                french: french,
                logoBytes: logoBytes,
              );
            },
            allowPrinting: false,
            allowSharing: false,
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            padding: const EdgeInsets.all(AppSpacing.sm),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _share(context, ref),
                icon: const Icon(Icons.share_outlined),
                label: Text(l10n.invoiceSharePdf),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
