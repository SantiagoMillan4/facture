import 'dart:async';

import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/purchase/application/purchase_providers.dart';
import 'package:facture/features/purchase/data/purchase_service.dart';
import 'package:facture/features/purchase/domain/purchase_catalog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FixedInvoices extends InvoicesNotifier {
  _FixedInvoices(this._invoices);

  final List<Invoice> _invoices;

  @override
  Future<List<Invoice>> build() async => _invoices;
}

class _HangingPurchaseService implements PurchaseService {
  @override
  Future<StoreProduct?> loadProduct() => Completer<StoreProduct?>().future;

  @override
  Stream<PurchaseUpdate> get updates => const Stream.empty();

  @override
  Future<void> buy(StoreProduct product) async {}

  @override
  Future<bool> restore() async => false;
}

/// Fake store that reports the Pro product as available. Unit tests never
/// touch the real StoreKit service: its constructor reaches the platform
/// channel, which has no binding in unit tests.
class _FakePurchaseService implements PurchaseService {
  @override
  Future<StoreProduct?> loadProduct() async =>
      const StoreProduct(id: PurchaseCatalog.proProductId, price: '32,99 \$');

  @override
  Stream<PurchaseUpdate> get updates => const Stream.empty();

  @override
  Future<void> buy(StoreProduct product) async {}

  @override
  Future<bool> restore() async => false;
}

Invoice _invoice(String id) => Invoice(
      id: id,
      number: '2026-$id',
      clientId: 'client-1',
      issueDate: DateTime(2026, 9, 1),
      dueDate: DateTime(2026, 10, 1),
    );

/// Reads [canCreateInvoiceProvider] once the purchase state settles.
Future<bool> _canCreate({
  required List<Invoice> invoices,
  bool isPro = false,
  PurchaseService? service,
}) async {
  SharedPreferences.setMockInitialValues({
    if (isPro)
      PurchaseCatalog.storageKey:
          '{"isPro": true, "purchasedAt": "2026-09-25T00:00:00.000Z"}',
  });
  final container = ProviderContainer(
    overrides: [
      invoicesProvider.overrideWith(() => _FixedInvoices(invoices)),
      purchaseServiceProvider
          .overrideWithValue(service ?? _FakePurchaseService()),
    ],
  );
  addTearDown(container.dispose);
  // Let both the purchase state and the invoice book finish loading.
  await container.read(purchaseProvider.future);
  await container.read(invoicesProvider.future);
  return container.read(canCreateInvoiceProvider);
}

void main() {
  test('free tier allows creating invoices under the limit', () async {
    expect(
      await _canCreate(
        invoices: [_invoice('1'), _invoice('2')],
      ),
      isTrue,
    );
  });

  test('free tier blocks creating invoices once the limit is reached',
      () async {
    expect(
      await _canCreate(
        invoices: [_invoice('1'), _invoice('2'), _invoice('3')],
      ),
      isFalse,
    );
  });

  test('Pro users can always create invoices', () async {
    expect(
      await _canCreate(
        invoices: List.generate(7, (i) => _invoice('$i')),
        isPro: true,
      ),
      isTrue,
    );
  });

  test('invoice count reflects the book size', () async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [
        invoicesProvider.overrideWith(
          () => _FixedInvoices([_invoice('1'), _invoice('2')]),
        ),
        purchaseServiceProvider.overrideWithValue(_FakePurchaseService()),
      ],
    );
    addTearDown(container.dispose);
    await container.read(invoicesProvider.future);
    expect(container.read(invoiceCountProvider), 2);
  });

  test('fail-open while the purchase state is still loading', () {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer(
      overrides: [
        invoicesProvider.overrideWith(
          () => _FixedInvoices([_invoice('1'), _invoice('2'), _invoice('3')]),
        ),
        purchaseServiceProvider.overrideWithValue(_HangingPurchaseService()),
      ],
    );
    addTearDown(container.dispose);
    // Start the purchase load but don't await it: with 3 invoices on the
    // free tier the gate must still allow creation while loading.
    container.read(purchaseProvider);
    expect(container.read(canCreateInvoiceProvider), isTrue);
  });
}
