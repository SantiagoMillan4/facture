import 'package:facture/features/clients/domain/client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const client = Client(
    id: 'c1',
    name: 'Acme Inc',
    email: 'billing@acme.example',
    phone: '514-555-0100',
    address: '123 Rue Principale',
    notes: 'Net 30',
    tpsNumber: '123456789RT0001',
    tvqNumber: '1234567890TQ0001',
  );

  group('Client', () {
    test('JSON round-trip preserves every field', () {
      expect(Client.fromJson(client.toJson()), client);
    });

    test('fromJson tolerates missing optional fields', () {
      final recovered = Client.fromJson({'id': 'c2', 'name': 'Solo'});

      expect(recovered.email, '');
      expect(recovered.phone, '');
      expect(recovered.address, '');
      expect(recovered.notes, '');
      expect(recovered.tpsNumber, isNull);
      expect(recovered.tvqNumber, isNull);
      expect(recovered.createdAt, isNull);
    });

    test('JSON round-trip preserves createdAt', () {
      final stamped = client.copyWith(createdAt: DateTime(2026, 9, 25, 12));

      expect(Client.fromJson(stamped.toJson()), stamped);
    });

    test('copyWith replaces only the given fields', () {
      final updated = client.copyWith(name: 'Acme 2', email: '');

      expect(updated.name, 'Acme 2');
      expect(updated.email, '');
      expect(updated.phone, client.phone);
      expect(updated.id, client.id);
    });

    test('equality is by value', () {
      expect(const Client(id: 'c1', name: 'A'), const Client(id: 'c1', name: 'A'));
      expect(
        const Client(id: 'c1', name: 'A'),
        isNot(const Client(id: 'c1', name: 'B')),
      );
    });
  });
}
