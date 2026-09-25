import 'package:facture/features/clients/data/clients_repository.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ClientsRepository', () {
    test('round-trips the directory through SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = ClientsRepository();
      const clients = [
        Client(id: 'c1', name: 'Acme Inc', email: 'billing@acme.example'),
        Client(id: 'c2', name: 'Solo', phone: '514-555-0100'),
      ];

      await repository.saveClients(clients);

      expect(await repository.loadClients(), clients);
    });

    test('loads an empty list when nothing was saved', () async {
      SharedPreferences.setMockInitialValues({});
      final repository = ClientsRepository();

      expect(await repository.loadClients(), isEmpty);
    });

    test('corrupted data resolves to an empty list, not a crash', () async {
      SharedPreferences.setMockInitialValues({
        ClientsRepository.storageKey: 'this is not json{{{',
      });
      final repository = ClientsRepository();

      expect(await repository.loadClients(), isEmpty);
    });
  });
}
