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

      await notifier.saveClient(const Client(id: 'c1', name: 'Acme'));
      expect(
        container.read(clientsProvider).value,
        [const Client(id: 'c1', name: 'Acme')],
      );

      await notifier.saveClient(
        const Client(id: 'c1', name: 'Acme Inc', email: 'b@acme.example'),
      );
      expect(
        container.read(clientsProvider).value,
        [const Client(id: 'c1', name: 'Acme Inc', email: 'b@acme.example')],
      );

      // Survives a fresh load: it was written to disk.
      expect(
        await ClientsRepository().loadClients(),
        [const Client(id: 'c1', name: 'Acme Inc', email: 'b@acme.example')],
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

      expect(
        container.read(clientsProvider).value,
        [const Client(id: 'c2', name: 'Solo')],
      );
      expect(await ClientsRepository().loadClients(), [
        const Client(id: 'c2', name: 'Solo'),
      ]);
    });
  });
}
