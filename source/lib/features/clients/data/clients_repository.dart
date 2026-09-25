import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/client.dart';

/// On-device client storage (local-first: no account, no cloud).
///
/// The whole directory is one JSON document under a versioned key.
/// Client lists are small (dozens, not thousands), so a single document
/// read/write per change is the right trade-off.
class ClientsRepository {
  static const storageKey = 'facture.clients.v1';

  /// Loads all clients, oldest first. Never throws: corrupted data
  /// resolves to an empty list rather than crashing the app.
  Future<List<Client>> loadClients() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Client.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveClients(List<Client> clients) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(clients.map((c) => c.toJson()).toList());
    await prefs.setString(storageKey, raw);
  }
}
