import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/catalog_repository.dart';
import '../domain/catalog_item.dart';

/// On-device catalog repository (SharedPreferences JSON document).
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepository();
});

/// The services/items catalog. Async because the first load reads from disk.
final catalogItemsProvider =
    AsyncNotifierProvider<CatalogItemsNotifier, List<CatalogItem>>(
        CatalogItemsNotifier.new);

class CatalogItemsNotifier extends AsyncNotifier<List<CatalogItem>> {
  @override
  Future<List<CatalogItem>> build() {
    return ref.watch(catalogRepositoryProvider).loadItems();
  }

  /// Inserts a new item or replaces the one with the same id, then
  /// persists the whole catalog.
  Future<void> saveItem(CatalogItem item) async {
    final current = state.value ?? [];
    final index = current.indexWhere((i) => i.id == item.id);
    final updated = List<CatalogItem>.of(current);
    if (index >= 0) {
      updated[index] = item;
    } else {
      updated.add(item);
    }
    await _persist(updated);
  }

  Future<void> deleteItem(String id) async {
    final current = state.value ?? [];
    await _persist(current.where((i) => i.id != id).toList());
  }

  Future<void> _persist(List<CatalogItem> updated) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(catalogRepositoryProvider).saveItems(updated);
      return updated;
    });
  }
}
