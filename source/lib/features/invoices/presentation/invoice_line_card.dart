import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/labeled_fields.dart';
import '../domain/quebec_tax.dart';
import 'line_draft.dart';

/// Editor for one invoice line: description, quantity, unit price, and a
/// live line total. [onRemove] is null when it's the last remaining row.
class InvoiceLineCard extends StatelessWidget {
  const InvoiceLineCard({
    super.key,
    required this.draft,
    required this.onChanged,
    this.onRemove,
  });

  final LineDraft draft;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lineTotal = dollarsToCents(draft.toLineItem()?.subtotal ?? 0);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: LabeledTextField(
                    controller: draft.descriptionController,
                    label: l10n.invoiceLineDescription,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onRemove,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: LabeledTextField(
                    controller: draft.quantityController,
                    label: l10n.invoiceLineQty,
                    hint: '1',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 3,
                  child: LabeledTextField(
                    controller: draft.unitPriceController,
                    label: l10n.invoiceLineUnitPrice,
                    hint: '0.00',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    suffixText: '\$',
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        l10n.invoiceTotal,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        formatCurrencyWithCents(
                          centsToDollars(lineTotal),
                          french: context.isFrench,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
