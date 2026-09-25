import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../domain/purchase_catalog.dart';

/// Store product info surfaced to the paywall UI.
class StoreProduct {
  const StoreProduct({required this.id, required this.price});

  final String id;

  /// Localized price string from the store (e.g. "32,99 $").
  final String price;
}

/// Terminal outcomes of a purchase attempt, delivered on [PurchaseService.updates].
enum PurchaseOutcome {
  /// The user completed a new purchase of the Pro product.
  purchased,

  /// A previous purchase of the Pro product was restored.
  restored,

  /// The user dismissed the purchase sheet.
  canceled,

  /// The purchase failed (network, store error, …).
  failed,

  /// The store is waiting on the user (e.g. parental approval).
  pending,
}

class PurchaseUpdate {
  const PurchaseUpdate({
    required this.outcome,
    required this.productId,
    this.errorMessage,
  });

  final PurchaseOutcome outcome;
  final String productId;
  final String? errorMessage;
}

/// Thin store boundary for the one-time Pro purchase.
///
/// The interface exists so [PurchaseNotifier] can be tested with a fake;
/// the real implementation delegates to the in_app_purchase plugin
/// (StoreKit on iOS). Purchase verification is store-side: a non-consumable
/// reported as purchased/restored by the store is trusted, which is the
/// standard approach for a local-first app with no backend.
abstract class PurchaseService {
  /// The currently loaded Pro product, or null when the store is
  /// unreachable or the product is not configured.
  Future<StoreProduct?> loadProduct();

  /// Purchase events from the store. The notifier subscribes once.
  Stream<PurchaseUpdate> get updates;

  /// Starts the system purchase sheet for [product].
  Future<void> buy(StoreProduct product);

  /// Asks the store to restore previous purchases. Returns true when a
  /// previous purchase of the Pro product was found.
  Future<bool> restore();
}

class StoreKitPurchaseService implements PurchaseService {
  StoreKitPurchaseService({InAppPurchase? store})
      : _store = store ?? InAppPurchase.instance;

  final InAppPurchase _store;

  /// ProductDetails cache backing [buy], keyed by product id.
  final Map<String, ProductDetails> _detailsCache = {};

  @override
  Future<StoreProduct?> loadProduct() async {
    try {
      if (!await _store.isAvailable()) return null;
      final response = await _store.queryProductDetails(
        {PurchaseCatalog.proProductId},
      );
      if (response.productDetails.isEmpty) return null;
      final details = response.productDetails.first;
      _detailsCache[details.id] = details;
      return StoreProduct(id: details.id, price: details.price);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<PurchaseUpdate> get updates =>
      _store.purchaseStream.expand(_mapDetails);

  Iterable<PurchaseUpdate> _mapDetails(
    List<PurchaseDetails> detailsList,
  ) sync* {
    for (final details in detailsList) {
      switch (details.status) {
        case PurchaseStatus.pending:
          yield PurchaseUpdate(
            outcome: PurchaseOutcome.pending,
            productId: details.productID,
          );
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          unawaited(_store.completePurchase(details));
          final isPro = details.productID == PurchaseCatalog.proProductId;
          yield PurchaseUpdate(
            outcome: isPro
                ? (details.status == PurchaseStatus.purchased
                    ? PurchaseOutcome.purchased
                    : PurchaseOutcome.restored)
                : PurchaseOutcome.failed,
            productId: details.productID,
            errorMessage: isPro ? null : 'Unknown product',
          );
        case PurchaseStatus.canceled:
          unawaited(_store.completePurchase(details));
          yield PurchaseUpdate(
            outcome: PurchaseOutcome.canceled,
            productId: details.productID,
          );
        case PurchaseStatus.error:
          unawaited(_store.completePurchase(details));
          yield PurchaseUpdate(
            outcome: PurchaseOutcome.failed,
            productId: details.productID,
            errorMessage: details.error?.message,
          );
      }
    }
  }

  @override
  Future<void> buy(StoreProduct product) async {
    final details = _detailsCache[product.id];
    if (details == null) {
      throw StateError('Product ${product.id} was not loaded');
    }
    await _store.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: details));
  }

  @override
  Future<bool> restore() async {
    final found = Completer<bool>();
    late final StreamSubscription<List<PurchaseDetails>> sub;
    sub = _store.purchaseStream.listen((detailsList) {
      for (final details in detailsList) {
        if (details.productID != PurchaseCatalog.proProductId) continue;
        if (details.status == PurchaseStatus.purchased ||
            details.status == PurchaseStatus.restored) {
          // The notifier's [updates] subscription also sees this event and
          // grants the entitlement; completing here only clears the queue.
          unawaited(_store.completePurchase(details));
          if (!found.isCompleted) found.complete(true);
        }
      }
    });
    try {
      await _store.restorePurchases();
      return await found.future.timeout(
        const Duration(seconds: 8),
        onTimeout: () => false,
      );
    } finally {
      await sub.cancel();
    }
  }
}
