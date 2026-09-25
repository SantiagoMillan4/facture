import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/invoice.dart';

/// On-device invoice storage (local-first: no account, no cloud).
///
/// The whole invoice book is one JSON document under a versioned key.
/// Freelancer invoice books are small (hundreds, not millions), so a
/// single document read/write per change is the right trade-off.
class InvoicesRepository {
  static const storageKey = 'facture.invoices.v1';

  /// Loads all invoices, oldest first. Never throws: corrupted data
  /// resolves to an empty list rather than crashing the app.
  Future<List<Invoice>> loadInvoices() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Invoice.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveInvoices(List<Invoice> invoices) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(invoices.map((i) => i.toJson()).toList());
    await prefs.setString(storageKey, raw);
  }
}
