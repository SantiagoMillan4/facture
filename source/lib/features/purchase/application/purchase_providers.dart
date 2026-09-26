import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../invoices/application/invoices_providers.dart';
import '../data/purchase_repository.dart';
import '../data/purchase_service.dart';
import '../domain/purchase_catalog.dart';
import '../domain/purchase_entitlement.dart';

/// Store boundary. Overridden with a fake in tests.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  return StoreKitPurchaseService();
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepository();
});

/// Transient paywall messages. The notifier stays locale-free; the UI maps
/// these to localized strings.
enum PurchaseNotice {
  /// The store is unreachable or the Pro product isn't configured.
  unavailable,

  /// The purchase failed.
  failed,

  /// A previous purchase was restored.
  restored,

  /// Restore found no previous purchase.
  nothingToRestore,
}

/// The Facture Pro purchase state machine.
///
/// - Entitlement is persisted locally and granted when the store reports a
///   purchase or restore of the Pro product.
/// - Product details (localized price) load once at startup; a null product
///   means the store is unreachable or the product isn't configured yet —
///   the paywall degrades to an "unavailable" message instead of crashing.
class PurchaseState {
  const PurchaseState({
    required this.isPro,
    this.product,
    this.isPurchasing = false,
    this.notice,
    this.noticeIsError = false,
  });

  final bool isPro;
  final StoreProduct? product;
  final bool isPurchasing;
  final PurchaseNotice? notice;
  final bool noticeIsError;

  PurchaseState copyWith({
    bool? isPro,
    StoreProduct? product,
    bool? isPurchasing,
    PurchaseNotice? notice,
    bool? noticeIsError,
  }) {
    return PurchaseState(
      isPro: isPro ?? this.isPro,
      product: product ?? this.product,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      notice: notice,
      noticeIsError: noticeIsError ?? false,
    );
  }
}

class PurchaseNotifier extends AsyncNotifier<PurchaseState> {
  StreamSubscription<PurchaseUpdate>? _updatesSub;

  @override
  Future<PurchaseState> build() async {
    final service = ref.watch(purchaseServiceProvider);
    final entitlement = await ref.watch(purchaseRepositoryProvider).load();
    _updatesSub?.cancel();
    _updatesSub = service.updates.listen(_onUpdate);
    ref.onDispose(() => _updatesSub?.cancel());
    final product = await service.loadProduct();
    return PurchaseState(isPro: entitlement.isPro, product: product);
  }

  /// Starts the system purchase sheet for the Pro product.
  Future<void> buyPro() async {
    final current = state.value;
    if (current == null || current.isPurchasing || current.isPro) return;
    var product = current.product;
    product ??= await ref.read(purchaseServiceProvider).loadProduct();
    if (product == null) {
      state = AsyncData(current.copyWith(
        notice: PurchaseNotice.unavailable,
        noticeIsError: true,
      ));
      return;
    }
    state = AsyncData(current.copyWith(
      isPurchasing: true,
      product: product,
    ));
    try {
      await ref.read(purchaseServiceProvider).buy(product);
    } catch (_) {
      state = AsyncData(current.copyWith(
        isPurchasing: false,
        notice: PurchaseNotice.failed,
        noticeIsError: true,
      ));
    }
    // The outcome arrives on [PurchaseService.updates].
  }

  /// Restores a previous Pro purchase from the store.
  Future<void> restorePurchases() async {
    final current = state.value;
    if (current == null || current.isPurchasing || current.isPro) return;
    state = AsyncData(current.copyWith(isPurchasing: true));
    final found = await ref.read(purchaseServiceProvider).restore();
    final latest = state.value;
    if (latest == null) return;
    if (latest.isPro) {
      // The updates stream granted the entitlement while restoring.
      state = AsyncData(latest.copyWith(
        isPurchasing: false,
        notice: PurchaseNotice.restored,
      ));
    } else if (!found) {
      state = AsyncData(latest.copyWith(
        isPurchasing: false,
        notice: PurchaseNotice.nothingToRestore,
        noticeIsError: true,
      ));
    } else {
      state = AsyncData(latest.copyWith(isPurchasing: false));
    }
  }

  Future<void> _onUpdate(PurchaseUpdate update) async {
    final current = state.value;
    if (current == null) return;
    switch (update.outcome) {
      case PurchaseOutcome.pending:
        state = AsyncData(current.copyWith(isPurchasing: true));
      case PurchaseOutcome.purchased:
      case PurchaseOutcome.restored:
        await ref
            .read(purchaseRepositoryProvider)
            .save(PurchaseEntitlement.pro());
        state = AsyncData(current.copyWith(
          isPro: true,
          isPurchasing: false,
          notice: update.outcome == PurchaseOutcome.restored
              ? PurchaseNotice.restored
              : null,
        ));
      case PurchaseOutcome.canceled:
        state = AsyncData(current.copyWith(isPurchasing: false));
      case PurchaseOutcome.failed:
        state = AsyncData(current.copyWith(
          isPurchasing: false,
          notice: PurchaseNotice.failed,
          noticeIsError: true,
        ));
    }
  }
}

final purchaseProvider =
    AsyncNotifierProvider<PurchaseNotifier, PurchaseState>(PurchaseNotifier.new);

/// Whether the user may create a new invoice right now: Pro users always,
/// free-tier users while under [PurchaseCatalog.freeInvoiceLimit].
///
/// Fail-open while the purchase state or the invoice book is still loading
/// so the UI never dead-ends on a spinner.
final canCreateInvoiceProvider = Provider<bool>((ref) {
  final purchase = ref.watch(purchaseProvider).value;
  if (purchase == null) return true;
  if (purchase.isPro) return true;
  final invoices = ref.watch(invoicesProvider).value;
  if (invoices == null) return true;
  return invoices.length < PurchaseCatalog.freeInvoiceLimit;
});

/// How many invoices exist (drives the free-tier usage label in Settings).
final invoiceCountProvider = Provider<int>((ref) {
  return ref.watch(invoicesProvider).value?.length ?? 0;
});
