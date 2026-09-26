import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/clients_repository.dart';
import '../domain/client.dart';

/// On-device client repository (SharedPreferences JSON document).
final clientsRepositoryProvider = Provider<ClientsRepository>((ref) {
  return ClientsRepository();
});

/// The client directory. Async because the first load reads from disk.
final clientsProvider =
    AsyncNotifierProvider<ClientsNotifier, List<Client>>(ClientsNotifier.new);

class ClientsNotifier extends AsyncNotifier<List<Client>> {
  @override
  Future<List<Client>> build() {
    return ref.watch(clientsRepositoryProvider).loadClients();
  }

  /// Inserts a new client or replaces the one with the same id, then
  /// persists the whole directory. New clients are stamped with the
  /// current time so the directory can sort by recency.
  Future<void> saveClient(Client client) async {
    final current = state.value ?? [];
    final index = current.indexWhere((c) => c.id == client.id);
    final updated = List<Client>.of(current);
    if (index >= 0) {
      updated[index] = client.copyWith(
        createdAt: client.createdAt ?? current[index].createdAt,
      );
    } else {
      updated.add(client.copyWith(createdAt: client.createdAt ?? DateTime.now()));
    }
    await _persist(updated);
  }

  Future<void> deleteClient(String id) async {
    final current = state.value ?? [];
    await _persist(current.where((c) => c.id != id).toList());
  }

  Future<void> _persist(List<Client> updated) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(clientsRepositoryProvider).saveClients(updated);
      return updated;
    });
  }
}

/// Generates a unique client id. Local-only: a timestamp plus a
/// microsecond counter is unique enough for an on-device directory.
String newClientId() =>
    'c${DateTime.now().microsecondsSinceEpoch}';
