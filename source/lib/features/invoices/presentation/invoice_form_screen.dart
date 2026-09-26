import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/adaptive_action_sheet.dart';
import '../../../shared/widgets/adaptive_date_field.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/labeled_choice_field.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../../business/application/business_profile_providers.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../catalog/presentation/catalog_picker_sheet.dart';
import '../../business/domain/business_profile.dart';
import '../../business/presentation/business_profile_screen.dart';
import '../../clients/application/clients_providers.dart';
import '../../clients/domain/client.dart';
import '../application/invoices_providers.dart';
import '../domain/invoice.dart';
import '../domain/quebec_tax.dart';
import 'client_picker_screen.dart';
import 'invoice_line_card.dart';
import 'invoice_preview_screen.dart';
import 'invoice_totals_card.dart';
import 'line_draft.dart';

/// Create / edit an invoice. `invoice` is null for a new invoice.
///
/// Sections: client, number + dates, status, line items with live
/// TPS/TVQ totals, taxes toggle, notes. Everything persists on-device
/// via [InvoicesNotifier].
class InvoiceFormScreen extends ConsumerStatefulWidget {
  const InvoiceFormScreen({super.key, this.invoice});

  final Invoice? invoice;

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  late final TextEditingController _numberController;
  late final TextEditingController _notesController;
  String? _clientId;
  late DateTime _issueDate;
  late DateTime _dueDate;
  InvoiceStatus _status = InvoiceStatus.draft;
  bool _chargeTaxes = false;
  // Set once the user manually flips the tax toggle: after that the
  // business profile no longer drives the default.
  //
  // Taxes start OFF on a new invoice: the form must never silently assume
  // the user is registered to collect TPS/TVQ. Declaring "registered" in
  // the business profile flips the default on (see _reconcileTaxDefault).
  var _taxesTouched = false;
  late List<LineDraft> _lines;
  String? _clientError;
  String? _linesError;
  var _saving = false;

  @override
  void initState() {
    super.initState();
    final invoice = widget.invoice;
    _notesController = TextEditingController(text: invoice?.notes ?? '');
    if (invoice == null) {
      final existing = ref.read(invoicesProvider).value ?? [];
      _numberController = TextEditingController(
        text: nextInvoiceNumber(existing),
      );
      _issueDate = DateTime.now();
      _dueDate = DateTime.now().add(const Duration(days: 30));
      // The tax default follows the declared business profile (registered
      // → on, small supplier → off). The profile loads async, so the
      // reconciliation happens in build() once it arrives. With no profile
      // the toggle stays off: registration is never assumed.
      _lines = [LineDraft()];
    } else {
      _numberController = TextEditingController(text: invoice.number);
      _clientId = invoice.clientId;
      _issueDate = invoice.issueDate;
      _dueDate = invoice.dueDate;
      // overdue is derived; the form edits the stored status.
      _status = invoice.status == InvoiceStatus.overdue
          ? InvoiceStatus.sent
          : invoice.status;
      _chargeTaxes = invoice.chargeTaxes;
      _lines = [
        for (final line in invoice.lines)
          LineDraft(
            id: line.id,
            description: line.description,
            quantity: _trimQty(line.quantity),
            unitPrice: line.unitPrice.toStringAsFixed(2),
          ),
        if (invoice.lines.isEmpty) LineDraft(),
      ];
    }
  }

  static String _trimQty(double qty) {
    final text = qty.toString();
    return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _notesController.dispose();
    for (final line in _lines) {
      line.dispose();
    }
    super.dispose();
  }

  List<InvoiceLineItem> get _validLines =>
      _lines.map((l) => l.toLineItem()).whereType<InvoiceLineItem>().toList();

  InvoiceTaxes get _taxes => taxesForInvoice(
    _validLines.map((l) => dollarsToCents(l.subtotal)),
    chargeTaxes: _chargeTaxes,
  );

  /// Applies the business profile's tax default to a new invoice once the
  /// profile finishes loading. Never overrides an existing invoice or a
  /// toggle the user flipped themselves.
  void _reconcileTaxDefault(BusinessProfile? profile) {
    if (widget.invoice != null || _taxesTouched || profile == null) return;
    final shouldCharge = profile.chargesTaxes;
    if (_chargeTaxes == shouldCharge) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _chargeTaxes = shouldCharge);
    });
  }

  Future<void> _pickClient() async {
    final client = await pushAppPage<Client>(
      context,
      (_) => const ClientPickerScreen(),
    );
    if (client != null) {
      setState(() {
        _clientId = client.id;
        _clientError = null;
      });
    }
  }

  /// Validates the form, showing inline errors. Returns the invoice built
  /// from the current form state, or null when invalid.
  Invoice? _validate() {
    final l10n = context.l10n;
    var ok = true;
    if (_clientId == null) {
      setState(() => _clientError = l10n.invoiceClientRequired);
      ok = false;
    }
    final lines = _validLines;
    if (lines.isEmpty || _lines.any((l) => !l.isBlank && !l.isValid)) {
      setState(() => _linesError = l10n.invoiceLinesRequired);
      ok = false;
    }
    if (!ok) return null;
    final existing = widget.invoice;
    return Invoice(
      id: existing?.id ?? newInvoiceId(),
      number: _numberController.text.trim().isEmpty
          ? nextInvoiceNumber(ref.read(invoicesProvider).value ?? [])
          : _numberController.text.trim(),
      clientId: _clientId!,
      issueDate: _issueDate,
      dueDate: _dueDate,
      lines: lines,
      status: _status,
      notes: _notesController.text.trim(),
      chargeTaxes: _chargeTaxes,
      paidDate: existing?.paidDate,
    );
  }

  /// Adds a line: a blank row directly when the catalog is empty,
  /// otherwise a native sheet offering a blank row or a catalog item.
  /// The form itself is unchanged — this only chooses the new row's
  /// starting values.
  Future<void> _addLine() async {
    final catalog = await ref.read(catalogItemsProvider.future);
    if (!mounted) return;
    if (catalog.isEmpty) {
      setState(() => _lines.add(LineDraft()));
      return;
    }
    final l10n = context.l10n;
    final choice = await showAdaptiveActionSheet<String>(
      context,
      title: l10n.invoiceAddLine,
      options: [
        ActionSheetOption(
          value: 'blank',
          label: l10n.invoiceAddBlankLine,
          icon: Icons.add,
        ),
        ActionSheetOption(
          value: 'catalog',
          label: l10n.invoiceAddFromCatalog,
          icon: Icons.inventory_2_outlined,
        ),
      ],
    );
    if (!mounted) return;
    if (choice == 'catalog') {
      final picked = await CatalogPickerSheet.show(context, catalog);
      if (picked == null || !mounted) return;
      setState(
        () => _lines.add(
          LineDraft(
            description: picked.description,
            quantity: '1',
            unitPrice: (picked.unitPriceCents / 100).toStringAsFixed(2),
          ),
        ),
      );
    } else if (choice == 'blank') {
      setState(() => _lines.add(LineDraft()));
    }
  }

  Future<void> _save() async {
    final invoice = _validate();
    if (invoice == null) return;
    setState(() => _saving = true);
    AppHaptics.confirm();
    await ref.read(invoicesProvider.notifier).saveInvoice(invoice);
    if (mounted) {
      // Saving lands on the invoice preview: the PDF as the client will see
      // it, with Share and Edit right there.
      pushReplacementAppPage(
        context,
        (_) => InvoicePreviewScreen(invoiceId: invoice.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clients = ref.watch(clientsProvider).value ?? [];
    final client = clients.where((c) => c.id == _clientId).firstOrNull;
    _reconcileTaxDefault(ref.watch(businessProfileProvider).value);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.invoice == null ? l10n.invoiceNewTitle : l10n.invoiceEditTitle,
        ),
        actions: [
          TextButton(onPressed: _saving ? null : _save, child: Text(l10n.save)),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            if (ref.watch(businessProfileProvider).value == null)
              _ProfileNudge(
                onTap: () =>
                    pushAppPage(context, (_) => const BusinessProfileScreen()),
              ),
            _ClientField(
              clientName: client?.name,
              error: _clientError,
              onTap: _pickClient,
            ),
            const SizedBox(height: AppSpacing.md),
            LabeledTextField(
              controller: _numberController,
              label: l10n.invoiceNumberLabel,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AdaptiveDateField(
                    label: l10n.invoiceIssueDate,
                    value: _issueDate,
                    onChanged: (d) => setState(() => _issueDate = d),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AdaptiveDateField(
                    label: l10n.invoiceDueDate,
                    value: _dueDate,
                    onChanged: (d) => setState(() => _dueDate = d),
                  ),
                ),
              ],
            ),
            LabeledChoiceField<InvoiceStatus>(
              label: l10n.invoiceStatusLabel,
              selected: _status,
              onChanged: (s) => setState(() => _status = s),
              options: [
                ChoiceOption(
                  value: InvoiceStatus.draft,
                  label: l10n.statusDraft,
                ),
                ChoiceOption(value: InvoiceStatus.sent, label: l10n.statusSent),
                ChoiceOption(value: InvoiceStatus.paid, label: l10n.statusPaid),
              ],
            ),
            SwitchListTile(
              title: Text(l10n.invoiceChargeTaxes),
              subtitle: Text(l10n.invoiceChargeTaxesHelper),
              value: _chargeTaxes,
              onChanged: (v) => setState(() {
                _taxesTouched = true;
                _chargeTaxes = v;
              }),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.invoiceLinesLabel,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            for (var i = 0; i < _lines.length; i++)
              InvoiceLineCard(
                draft: _lines[i],
                onChanged: () => setState(() => _linesError = null),
                onRemove: _lines.length > 1
                    ? () => setState(() {
                        _lines[i].dispose();
                        _lines.removeAt(i);
                      })
                    : null,
              ),
            if (_linesError != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  _linesError!,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
            OutlinedButton.icon(
              onPressed: _addLine,
              icon: const Icon(Icons.add),
              label: Text(l10n.invoiceAddLine),
            ),
            const SizedBox(height: AppSpacing.md),
            InvoiceTotalsCard(taxes: _taxes, chargeTaxes: _chargeTaxes),
            const SizedBox(height: AppSpacing.md),
            LabeledTextField(
              controller: _notesController,
              label: l10n.invoiceNotesLabel,
              hint: l10n.invoiceNotesHint,
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _save(),
            ),
          ],
        ),
      ),
    );
  }
}

/// The client row: shows the picked client or the "select" prompt, with
/// an inline validation error.
class _ClientField extends StatelessWidget {
  const _ClientField({
    required this.clientName,
    required this.error,
    required this.onTap,
  });

  final String? clientName;
  final String? error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.invoiceClientLabel,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline),
              errorText: error,
            ),
            child: Text(
              clientName ?? l10n.invoiceSelectClient,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: clientName == null
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// One-time nudge shown until the business profile exists: without it the
/// invoice PDF has no business header and the tax default is just a guess.
class _ProfileNudge extends StatelessWidget {
  const _ProfileNudge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              Icons.business_outlined,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                l10n.invoiceProfileNudge,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            TextButton(
              onPressed: onTap,
              child: Text(l10n.invoiceProfileNudgeAction),
            ),
          ],
        ),
      ),
    );
  }
}
