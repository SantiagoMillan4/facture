import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/catalog_item.dart';

/// On-device services/items catalog (local-first: no account, no cloud).
///
/// The whole catalog is one JSON document under a versioned key.
class CatalogRepository {
  static const storageKey = 'facture.catalog_items.v1';

  /// Loads all items, oldest first. Never throws: corrupted data resolves
  /// to an empty list rather than crashing the app.
  Future<List<CatalogItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CatalogItem.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveItems(List<CatalogItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((i) => i.toJson()).toList());
    await prefs.setString(storageKey, raw);
  }
}
