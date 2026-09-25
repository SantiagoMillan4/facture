/// Store catalog constants for the one-time Facture Pro purchase.
class PurchaseCatalog {
  /// Non-consumable product id. Must match the product created in
  /// App Store Connect (and the local Facture.storekit config).
  static const proProductId = 'com.santiago.facture.pro';

  /// Free tier: how many invoices can be created before the paywall.
  static const freeInvoiceLimit = 3;

  /// SharedPreferences key for the locally persisted entitlement.
  static const storageKey = 'facture.purchase.v1';
}
