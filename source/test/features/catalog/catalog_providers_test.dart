import 'package:facture/features/catalog/application/catalog_providers.dart';
import 'package:facture/features/catalog/domain/catalog_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('CatalogItemsNotifier', () {
    test('saves, updates and deletes items', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Starts empty.
      expect(await container.read(catalogItemsProvider.future), isEmpty);

      const item = CatalogItem(
        id: 'ci1',
        description: 'Design',
        unitPriceCents: 5000,
      );
      await container.read(catalogItemsProvider.notifier).saveItem(item);
      expect(
        await container.read(catalogItemsProvider.future),
        [item],
      );

      // Same id replaces.
      final updated = item.copyWith(unitPriceCents: 6000);
      await container.read(catalogItemsProvider.notifier).saveItem(updated);
      expect(
        await container.read(catalogItemsProvider.future),
        [updated],
      );

      await container.read(catalogItemsProvider.notifier).deleteItem('ci1');
      expect(await container.read(catalogItemsProvider.future), isEmpty);
    });
  });
}
