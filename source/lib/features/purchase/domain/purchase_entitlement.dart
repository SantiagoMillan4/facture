/// The user's Facture Pro entitlement.
///
/// Local-first: the entitlement lives on the device (no account, no
/// backend). It is granted when StoreKit reports a purchase or a restore
/// of the non-consumable Pro product, and persisted so it survives
/// reinstalls of the app data — a fresh install re-grants it via
/// "Restore purchases".
class PurchaseEntitlement {
  const PurchaseEntitlement({required this.isPro, this.purchasedAt});

  final bool isPro;
  final DateTime? purchasedAt;

  factory PurchaseEntitlement.free() =>
      const PurchaseEntitlement(isPro: false);

  factory PurchaseEntitlement.pro({DateTime? purchasedAt}) =>
      PurchaseEntitlement(isPro: true, purchasedAt: purchasedAt);

  factory PurchaseEntitlement.fromJson(Map<String, dynamic> json) {
    final purchasedAt = json['purchasedAt'];
    return PurchaseEntitlement(
      isPro: json['isPro'] == true,
      purchasedAt: purchasedAt is String
          ? DateTime.tryParse(purchasedAt)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'isPro': isPro,
        'purchasedAt': purchasedAt?.toIso8601String(),
      };
}
