import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/big_add_button.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/staggered_entrance.dart';
import '../../../shared/widgets/swipe_to_delete_tile.dart';
import '../application/catalog_providers.dart';
import '../domain/catalog_item.dart';
import 'catalog_item_edit_screen.dart';

/// The services/items catalog: reusable invoice line items with a
/// default unit price. Saved items can be dropped into any invoice
/// in one tap from the invoice form.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  void _openEditor(BuildContext context, [CatalogItem? item]) {
    pushAppPage(context, (_) => CatalogItemEditScreen(item: item));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final french = context.isFrench;
    final itemsAsync = ref.watch(catalogItemsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.catalogTitle)),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (items) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
              child: BigAddButton(
                key: const ValueKey('addCatalogItemButton'),
                label: l10n.catalogAddItem,
                onPressed: () => _openEditor(context),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: l10n.catalogEmptyTitle,
                      message: l10n.catalogEmptyMessage,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.xs,
                        AppSpacing.lg,
                        AppSpacing.lg,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return StaggeredEntrance(
                          index: index,
                          child: SwipeToDeleteTile(
                            key: ValueKey('catalog-${item.id}'),
                            onDelete: () => ref
                                .read(catalogItemsProvider.notifier)
                                .deleteItem(item.id),
                            child: ListTile(
                              title: Text(item.description),
                              trailing: Text(
                                formatCurrencyWithCents(
                                  item.unitPriceCents / 100,
                                  french: french,
                                ),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              onTap: () => _openEditor(context, item),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
