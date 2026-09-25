import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/purchase_catalog.dart';
import '../domain/purchase_entitlement.dart';

/// On-device Pro entitlement storage (local-first: no account, no cloud).
/// Never throws: corrupted or missing data resolves to the free tier.
class PurchaseRepository {
  Future<PurchaseEntitlement> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(PurchaseCatalog.storageKey);
    if (raw == null || raw.isEmpty) return PurchaseEntitlement.free();
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return PurchaseEntitlement.free();
      return PurchaseEntitlement.fromJson(decoded);
    } catch (_) {
      return PurchaseEntitlement.free();
    }
  }

  Future<void> save(PurchaseEntitlement entitlement) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      PurchaseCatalog.storageKey,
      jsonEncode(entitlement.toJson()),
    );
  }
}
