import 'dart:convert';

import 'package:facture/features/catalog/domain/catalog_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CatalogItem JSON', () {
    test('round-trips through toJson/fromJson', () {
      const item = CatalogItem(
        id: 'ci1',
        description: 'Logo design',
        unitPriceCents: 7500,
      );
      final restored = CatalogItem.fromJson(
        jsonDecode(jsonEncode(item.toJson())) as Map<String, dynamic>,
      );
      expect(restored, item);
    });

    test('copyWith replaces fields', () {
      const item = CatalogItem(
        id: 'ci1',
        description: 'Logo design',
        unitPriceCents: 7500,
      );
      final updated = item.copyWith(unitPriceCents: 8000);
      expect(updated.unitPriceCents, 8000);
      expect(updated.description, 'Logo design');
    });
  });
}
