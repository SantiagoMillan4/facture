import 'package:facture/features/clients/application/clients_providers.dart';
import 'package:facture/features/clients/data/clients_repository.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('ClientsNotifier', () {
    test('starts empty', () async {
      SharedPreferences.setMockInitialValues({});
      final container = makeContainer();

      expect(await container.read(clientsProvider.future), isEmpty);
    });

    test('saveClient inserts, updates by id, and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final container = makeContainer();
      final notifier = container.read(clientsProvider.notifier);
      await container.read(clientsProvider.future);

      List<Client> saved() => container.read(clientsProvider).value!;

      await notifier.saveClient(const Client(id: 'c1', name: 'Acme'));
      // New clients are stamped with the current time.
      expect(saved().single.id, 'c1');
      expect(saved().single.name, 'Acme');
      expect(saved().single.createdAt, isNotNull);
      final stampedAt = saved().single.createdAt;

      await notifier.saveClient(
        const Client(id: 'c1', name: 'Acme Inc', email: 'b@acme.example'),
      );
      // Updating keeps the original timestamp.
      expect(saved().single.createdAt, stampedAt);
      expect(saved().single.name, 'Acme Inc');
      expect(saved().single.email, 'b@acme.example');

      // Survives a fresh load: it was written to disk (timestamps persist
      // at millisecond precision).
      final fromDisk = await ClientsRepository().loadClients();
      expect(fromDisk.single.id, 'c1');
      expect(fromDisk.single.name, 'Acme Inc');
      expect(fromDisk.single.email, 'b@acme.example');
      expect(
        fromDisk.single.createdAt?.millisecondsSinceEpoch,
        stampedAt?.millisecondsSinceEpoch,
      );
    });

    test('deleteClient removes the client and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final container = makeContainer();
      final notifier = container.read(clientsProvider.notifier);
      await container.read(clientsProvider.future);

      await notifier.saveClient(const Client(id: 'c1', name: 'Acme'));
      await notifier.saveClient(const Client(id: 'c2', name: 'Solo'));
      await notifier.deleteClient('c1');

      final remaining = container.read(clientsProvider).value!;
      expect(remaining.single.id, 'c2');
      expect(remaining.single.name, 'Solo');
      final fromDisk = await ClientsRepository().loadClients();
      expect(fromDisk.single.id, 'c2');
      expect(fromDisk.single.name, 'Solo');
    });
  });
}
