import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/adaptive_date_field.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/labeled_choice_field.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../../clients/application/clients_providers.dart';
import '../../clients/domain/client.dart';
import '../application/invoices_providers.dart';
import '../domain/invoice.dart';
import '../domain/quebec_tax.dart';
import 'client_picker_screen.dart';
import 'invoice_line_card.dart';
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
  bool _chargeTaxes = true;
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
      final existing = ref.read(invoicesProvider).valueOrNull ?? [];
      _numberController = TextEditingController(
        text: nextInvoiceNumber(existing),
      );
      _issueDate = DateTime.now();
      _dueDate = DateTime.now().add(const Duration(days: 30));
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

  Future<void> _save() async {
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
    if (!ok) return;

    setState(() => _saving = true);
    final existing = widget.invoice;
    final invoice = Invoice(
      id: existing?.id ?? newInvoiceId(),
      number: _numberController.text.trim().isEmpty
          ? nextInvoiceNumber(ref.read(invoicesProvider).valueOrNull ?? [])
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
    AppHaptics.confirm();
    await ref.read(invoicesProvider.notifier).saveInvoice(invoice);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final clients = ref.watch(clientsProvider).valueOrNull ?? [];
    final client = clients.where((c) => c.id == _clientId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.invoice == null ? l10n.invoiceNewTitle : l10n.invoiceEditTitle,
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(l10n.save),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
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
                    value: InvoiceStatus.draft, label: l10n.statusDraft),
                ChoiceOption(
                    value: InvoiceStatus.sent, label: l10n.statusSent),
                ChoiceOption(
                    value: InvoiceStatus.paid, label: l10n.statusPaid),
              ],
            ),
            SwitchListTile(
              title: Text(l10n.invoiceChargeTaxes),
              subtitle: Text(l10n.invoiceChargeTaxesHelper),
              value: _chargeTaxes,
              onChanged: (v) => setState(() => _chargeTaxes = v),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l10n.invoiceLinesLabel,
                style: Theme.of(context).textTheme.bodyMedium),
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
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.xs),
            OutlinedButton.icon(
              onPressed: () => setState(() => _lines.add(LineDraft())),
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
        Text(l10n.invoiceClientLabel,
            style: Theme.of(context).textTheme.bodyMedium),
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
