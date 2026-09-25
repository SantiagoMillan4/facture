import 'dart:async';

import 'package:facture/features/purchase/application/purchase_providers.dart';
import 'package:facture/features/purchase/data/purchase_repository.dart';
import 'package:facture/features/purchase/data/purchase_service.dart';
import 'package:facture/features/purchase/domain/purchase_catalog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakePurchaseService implements PurchaseService {
  FakePurchaseService({this.product});

  final StoreProduct? product;
  final _controller = StreamController<PurchaseUpdate>.broadcast();

  bool restoreResult = false;
  bool buyCalled = false;

  @override
  Future<StoreProduct?> loadProduct() async => product;

  @override
  Stream<PurchaseUpdate> get updates => _controller.stream;

  @override
  Future<void> buy(StoreProduct product) async {
    buyCalled = true;
  }

  @override
  Future<bool> restore() async => restoreResult;

  void emit(PurchaseUpdate update) => _controller.add(update);

  void dispose() => _controller.close();
}

const _proProduct = StoreProduct(
  id: PurchaseCatalog.proProductId,
  price: '32,99 \$',
);

PurchaseUpdate _update(PurchaseOutcome outcome) => PurchaseUpdate(
      outcome: outcome,
      productId: PurchaseCatalog.proProductId,
    );

ProviderContainer _container(FakePurchaseService service) {
  return ProviderContainer(
    overrides: [purchaseServiceProvider.overrideWithValue(service)],
  );
}

Future<PurchaseState> _readyState(ProviderContainer container) async {
  container.read(purchaseProvider);
  return container.read(purchaseProvider.future);
}

Future<void> _settle() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts free with the store product loaded', () async {
    final service = FakePurchaseService(product: _proProduct);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });

    final state = await _readyState(container);
    expect(state.isPro, isFalse);
    expect(state.product?.price, '32,99 \$');
    expect(state.isPurchasing, isFalse);
  });

  test('a purchased event grants Pro and persists it', () async {
    final service = FakePurchaseService(product: _proProduct);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    service.emit(_update(PurchaseOutcome.purchased));
    await _settle();

    final state = container.read(purchaseProvider).value!;
    expect(state.isPro, isTrue);
    expect(state.isPurchasing, isFalse);
    // Survives a fresh notifier: the entitlement was persisted.
    expect((await PurchaseRepository().load()).isPro, isTrue);
  });

  test('buyPro starts the store purchase sheet', () async {
    final service = FakePurchaseService(product: _proProduct);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    await container.read(purchaseProvider.notifier).buyPro();
    expect(service.buyCalled, isTrue);
    expect(
      container.read(purchaseProvider).value!.isPurchasing,
      isTrue,
    );
  });

  test('a failed purchase surfaces an error notice, stays free', () async {
    final service = FakePurchaseService(product: _proProduct);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    await container.read(purchaseProvider.notifier).buyPro();
    service.emit(_update(PurchaseOutcome.failed));
    await _settle();

    final state = container.read(purchaseProvider).value!;
    expect(state.isPro, isFalse);
    expect(state.isPurchasing, isFalse);
    expect(state.notice, PurchaseNotice.failed);
    expect(state.noticeIsError, isTrue);
  });

  test('a canceled purchase clears the busy state without an error',
      () async {
    final service = FakePurchaseService(product: _proProduct);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    await container.read(purchaseProvider.notifier).buyPro();
    service.emit(_update(PurchaseOutcome.canceled));
    await _settle();

    final state = container.read(purchaseProvider).value!;
    expect(state.isPro, isFalse);
    expect(state.isPurchasing, isFalse);
    expect(state.notice, isNull);
  });

  test('buyPro with no store product shows the unavailable notice', () async {
    final service = FakePurchaseService(product: null);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    await container.read(purchaseProvider.notifier).buyPro();

    final state = container.read(purchaseProvider).value!;
    expect(service.buyCalled, isFalse);
    expect(state.notice, PurchaseNotice.unavailable);
    expect(state.noticeIsError, isTrue);
  });

  test('restore with no previous purchase shows the nothing-to-restore notice',
      () async {
    final service = FakePurchaseService(product: _proProduct)
      ..restoreResult = false;
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    await container.read(purchaseProvider.notifier).restorePurchases();
    await _settle();

    final state = container.read(purchaseProvider).value!;
    expect(state.isPro, isFalse);
    expect(state.isPurchasing, isFalse);
    expect(state.notice, PurchaseNotice.nothingToRestore);
  });

  test('restore grants Pro when the store reports a restored purchase',
      () async {
    final service = FakePurchaseService(product: _proProduct)
      ..restoreResult = true;
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });
    await _readyState(container);

    // The real service sees the restored transaction on the purchase
    // stream while restore() is in flight; the fake emits it directly.
    final restoring =
        container.read(purchaseProvider.notifier).restorePurchases();
    service.emit(_update(PurchaseOutcome.restored));
    await restoring;
    await _settle();

    final state = container.read(purchaseProvider).value!;
    expect(state.isPro, isTrue);
    expect(state.isPurchasing, isFalse);
    expect(state.notice, PurchaseNotice.restored);
    expect((await PurchaseRepository().load()).isPro, isTrue);
  });

  test('already-Pro users skip buy and restore', () async {
    SharedPreferences.setMockInitialValues({
      PurchaseCatalog.storageKey:
          '{"isPro": true, "purchasedAt": "2026-09-25T00:00:00.000Z"}',
    });
    final service = FakePurchaseService(product: _proProduct);
    final container = _container(service);
    addTearDown(() {
      container.dispose();
      service.dispose();
    });

    final state = await _readyState(container);
    expect(state.isPro, isTrue);

    await container.read(purchaseProvider.notifier).buyPro();
    await container.read(purchaseProvider.notifier).restorePurchases();
    expect(service.buyCalled, isFalse);
  });
}
