import 'package:facture/features/purchase/data/purchase_repository.dart';
import 'package:facture/features/purchase/domain/purchase_entitlement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('missing data resolves to the free tier', () async {
    final repo = PurchaseRepository();
    final entitlement = await repo.load();
    expect(entitlement.isPro, isFalse);
  });

  test('pro entitlement survives a save/load round trip', () async {
    final repo = PurchaseRepository();
    await repo.save(PurchaseEntitlement.pro(
      purchasedAt: DateTime.utc(2026, 9, 25),
    ));

    final loaded = await repo.load();
    expect(loaded.isPro, isTrue);
    expect(loaded.purchasedAt, DateTime.utc(2026, 9, 25));
  });

  test('corrupted data resolves to the free tier, never throws', () async {
    SharedPreferences.setMockInitialValues({
      'facture.purchase.v1': 'not-json{{{',
    });
    final repo = PurchaseRepository();
    final entitlement = await repo.load();
    expect(entitlement.isPro, isFalse);
  });

  test('wrong-shaped JSON resolves to the free tier', () async {
    SharedPreferences.setMockInitialValues({
      'facture.purchase.v1': '["isPro", true]',
    });
    final repo = PurchaseRepository();
    expect((await repo.load()).isPro, isFalse);
  });
}
