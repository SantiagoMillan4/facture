import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/clients/domain/client_sort.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Client client(String name, {DateTime? createdAt}) =>
      Client(id: name, name: name, createdAt: createdAt);

  group('ClientSort', () {
    test('nameAsc sorts alphabetically, case-insensitive', () {
      final sorted = [client('beta'), client('Alpha'), client('gamma')]
        ..sort(ClientSort.nameAsc.compare);

      expect(sorted.map((c) => c.name), ['Alpha', 'beta', 'gamma']);
    });

    test('nameDesc reverses nameAsc', () {
      final sorted = [client('beta'), client('Alpha'), client('gamma')]
        ..sort(ClientSort.nameDesc.compare);

      expect(sorted.map((c) => c.name), ['gamma', 'beta', 'Alpha']);
    });

    test('newestFirst puts the most recently added client first', () {
      final old = client('Old', createdAt: DateTime(2026, 1, 1));
      final recent = client('Recent', createdAt: DateTime(2026, 9, 1));
      final sorted = [old, recent]..sort(ClientSort.newestFirst.compare);

      expect(sorted.map((c) => c.name), ['Recent', 'Old']);
    });

    test('oldestFirst puts the earliest added client first', () {
      final old = client('Old', createdAt: DateTime(2026, 1, 1));
      final recent = client('Recent', createdAt: DateTime(2026, 9, 1));
      final sorted = [recent, old]..sort(ClientSort.oldestFirst.compare);

      expect(sorted.map((c) => c.name), ['Old', 'Recent']);
    });

    test('clients without createdAt count as oldest', () {
      final legacy = client('Legacy');
      final recent = client('Recent', createdAt: DateTime(2026, 9, 1));

      final newest = [legacy, recent]..sort(ClientSort.newestFirst.compare);
      expect(newest.map((c) => c.name), ['Recent', 'Legacy']);

      final oldest = [recent, legacy]..sort(ClientSort.oldestFirst.compare);
      expect(oldest.map((c) => c.name), ['Legacy', 'Recent']);
    });

    test('recency ties fall back to name order', () {
      final stamp = DateTime(2026, 9, 1);
      final sorted = [client('Beta', createdAt: stamp), client('Alpha', createdAt: stamp)]
        ..sort(ClientSort.newestFirst.compare);

      expect(sorted.map((c) => c.name), ['Alpha', 'Beta']);
    });

    test('fromStorageKey falls back to nameAsc for unknown keys', () {
      expect(ClientSort.fromStorageKey(null), ClientSort.nameAsc);
      expect(ClientSort.fromStorageKey('bogus'), ClientSort.nameAsc);
      expect(
        ClientSort.fromStorageKey(ClientSort.newestFirst.storageKey),
        ClientSort.newestFirst,
      );
    });
  });
}
