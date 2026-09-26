import 'dart:convert';

import 'package:facture/features/backup/domain/backup_payload.dart';
import 'package:flutter_test/flutter_test.dart';

BackupPayload _payload() => BackupPayload(
      exportedAt: DateTime(2026, 9, 25, 12),
      invoices: [
        {'id': 'i1', 'number': '2026-0001'},
      ],
      clients: [
        {'id': 'c1', 'name': 'Acme'},
      ],
      businessProfile: {'name': 'Santiago'},
      emailTemplate: {'subject': 'Hi', 'body': 'Bye'},
    );

void main() {
  group('BackupPayload', () {
    test('round-trips through toJson/parse', () {
      final parsed = BackupPayload.parse(
        jsonDecode(jsonEncode(_payload().toJson())) as Map<String, dynamic>,
      );
      expect(parsed.invoices, hasLength(1));
      expect(parsed.clients, hasLength(1));
      expect(parsed.businessProfile?['name'], 'Santiago');
      expect(parsed.emailTemplate?['subject'], 'Hi');
      expect(parsed.exportedAt, DateTime(2026, 9, 25, 12));
    });

    test('optional sections may be absent', () {
      final parsed = BackupPayload.parse({
        'format': 'facture-backup',
        'version': 1,
        'invoices': [],
        'clients': [],
      });
      expect(parsed.businessProfile, isNull);
      expect(parsed.emailTemplate, isNull);
    });

    test('rejects a foreign document', () {
      expect(
        () => BackupPayload.parse({'format': 'something-else', 'version': 1}),
        throwsFormatException,
      );
    });

    test('rejects a newer version', () {
      expect(
        () => BackupPayload.parse({'format': 'facture-backup', 'version': 99}),
        throwsFormatException,
      );
    });

    test('rejects a malformed invoices section', () {
      expect(
        () => BackupPayload.parse({
          'format': 'facture-backup',
          'version': 1,
          'invoices': 'nope',
          'clients': [],
        }),
        throwsFormatException,
      );
    });
  });
}
