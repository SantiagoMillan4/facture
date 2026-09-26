import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../domain/catalog_item.dart';

/// Bottom sheet listing the catalog items. Tapping one returns it so the
/// caller can drop it into an invoice line; dismissing returns null.
class CatalogPickerSheet extends StatelessWidget {
  const CatalogPickerSheet({super.key, required this.items});

  final List<CatalogItem> items;

  static Future<CatalogItem?> show(
    BuildContext context,
    List<CatalogItem> items,
  ) {
    return showModalBottomSheet<CatalogItem>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => CatalogPickerSheet(items: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final french = context.isFrench;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xs,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(
              l10n.catalogPickTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(item.description),
                  trailing: Text(
                    formatCurrencyWithCents(
                      item.unitPriceCents / 100,
                      french: french,
                    ),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  onTap: () => Navigator.of(context).pop(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
