import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../domain/quebec_tax.dart';

/// Live invoice totals: subtotal, TPS/TVQ breakdown (when taxes are
/// charged), and the grand total. Amounts are derived, never stored.
class InvoiceTotalsCard extends StatelessWidget {
  const InvoiceTotalsCard({
    super.key,
    required this.taxes,
    required this.chargeTaxes,
  });

  final InvoiceTaxes taxes;
  final bool chargeTaxes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final french = context.isFrench;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _TotalRow(
              label: l10n.invoiceSubtotal,
              cents: taxes.subtotalCents,
              french: french,
            ),
            if (chargeTaxes) ...[
              _TotalRow(
                label: 'TPS (5 %)',
                cents: taxes.tpsCents,
                french: french,
              ),
              _TotalRow(
                label: 'TVQ (9,975 %)',
                cents: taxes.tvqCents,
                french: french,
              ),
            ],
            const Divider(),
            _TotalRow(
              label: l10n.invoiceTotal,
              cents: taxes.totalCents,
              french: french,
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
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
            style: style,
          ),
        ],
      ),
    );
  }
}
