import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../../invoices/domain/quebec_tax.dart';

/// Quick TPS/TVQ calculator: add taxes to a pre-tax amount, or recover the
/// pre-tax amount and tax breakdown from a tax-included total.
///
/// Uses the exact same tax domain as invoices ([taxesForLine] /
/// [extractTaxes]), so the numbers here always agree with the numbers on
/// an invoice. Stateless math — nothing is saved.
class TaxCalculatorScreen extends StatefulWidget {
  const TaxCalculatorScreen({super.key});

  @override
  State<TaxCalculatorScreen> createState() => _TaxCalculatorScreenState();
}

enum _CalcMode { addTaxes, extractTaxes }

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  static const _rates = QuebecTaxRates();

  final _amountController = TextEditingController();
  var _mode = _CalcMode.addTaxes;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Parses the amount field leniently: accepts both `115.47` and
  /// `115,47` (French decimal comma), ignores stray spaces and `$`.
  int get _inputCents {
    final cleaned = _amountController.text
        .replaceAll(' ', '')
        .replaceAll('\u00a0', '')
        .replaceAll('\$', '')
        .replaceAll(',', '.');
    final value = double.tryParse(cleaned);
    if (value == null || value.isNaN) return 0;
    return dollarsToCents(value.clamp(0, 999999999).toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final french = context.isFrench;
    final inputCents = _inputCents;
    final breakdown = _mode == _CalcMode.addTaxes
        ? taxesForLine(inputCents, rates: _rates)
        : extractTaxes(inputCents, rates: _rates);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.toolsTaxCalculator)),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SegmentedButton<_CalcMode>(
              segments: [
                ButtonSegment(
                  value: _CalcMode.addTaxes,
                  label: Text(l10n.calcAddTaxes),
                  icon: const Icon(Icons.add),
                ),
                ButtonSegment(
                  value: _CalcMode.extractTaxes,
                  label: Text(l10n.calcExtractTaxes),
                  icon: const Icon(Icons.remove),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (selection) =>
                  setState(() => _mode = selection.first),
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledAmountField(
              controller: _amountController,
              label: l10n.calcAmountLabel,
              hint: '0.00',
              suffixText: '\$',
              textInputAction: TextInputAction.done,
              onChanged: (_) => setState(() {}),
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    if (_mode == _CalcMode.extractTaxes)
                      _ResultRow(
                        label: l10n.calcPreTaxAmount,
                        cents: breakdown.subtotalCents,
                        french: french,
                        emphasized: true,
                      ),
                    _ResultRow(
                      label: 'TPS ${_rateLabel(_rates.tpsPercent, french)}',
                      cents: breakdown.tpsCents,
                      french: french,
                    ),
                    _ResultRow(
                      label: 'TVQ ${_rateLabel(_rates.tvqPercent, french)}',
                      cents: breakdown.tvqCents,
                      french: french,
                    ),
                    const Divider(),
                    if (_mode == _CalcMode.addTaxes)
                      _ResultRow(
                        label: l10n.calcTotalWithTaxes,
                        cents: breakdown.totalCents,
                        french: french,
                        emphasized: true,
                      )
                    else
                      _ResultRow(
                        label: l10n.calcTotalWithTaxes,
                        cents: inputCents,
                        french: french,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'TPS ${_rateLabel(_rates.tpsPercent, french)} · '
              'TVQ ${_rateLabel(_rates.tvqPercent, french)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _rateLabel(double rate, bool french) {
  var text = rate.toString();
  if (text.endsWith('.0')) text = text.substring(0, text.length - 2);
  if (french) text = text.replaceAll('.', ',');
  return french ? '$text %' : '$text%';
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.cents,
    required this.french,
    this.emphasized = false,
  });

  final String label;
  final int cents;
  final bool french;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = emphasized
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyLarge;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            formatCurrencyWithCents(centsToDollars(cents), french: french),
            style: style?.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
