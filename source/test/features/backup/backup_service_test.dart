import 'dart:convert';

import 'package:facture/features/backup/application/backup_service.dart';
import 'package:facture/features/business/data/business_profile_repository.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/clients/data/clients_repository.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/email/data/email_template_repository.dart';
import 'package:facture/features/email/domain/email_template.dart';
import 'package:facture/features/invoices/data/invoices_repository.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

BackupService _service() => BackupService(
      invoices: InvoicesRepository(),
      clients: ClientsRepository(),
      business: BusinessProfileRepository(),
      email: EmailTemplateRepository(),
    );

Invoice _invoice() => Invoice(
      id: 'i1',
      number: '2026-0001',
      clientId: 'c1',
      issueDate: DateTime(2026, 9, 25),
      dueDate: DateTime(2026, 10, 25),
      lines: const [
        InvoiceLineItem(
          id: 'l1',
          description: 'Design',
          quantity: 2,
          unitPrice: 50,
        ),
      ],
      chargeTaxes: true,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('BackupService', () {
    test('export then import round-trips the whole database', () async {
      final service = _service();
      await InvoicesRepository().saveInvoices([_invoice()]);
      await ClientsRepository()
          .saveClients([const Client(id: 'c1', name: 'Acme')]);
      await BusinessProfileRepository().saveProfile(
        const BusinessProfile(name: 'Santiago'),
      );
      await EmailTemplateRepository().saveTemplate(
        const EmailTemplate(subject: 'Hi', body: 'Bye'),
      );

      final file = await service.writeBackupFile();
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      expect(decoded['format'], 'facture-backup');

      // Wipe everything, then restore.
      await InvoicesRepository().saveInvoices([]);
      await ClientsRepository().saveClients([]);
      final summary = await service.restoreFromJson(raw);
      expect(summary.invoiceCount, 1);
      expect(summary.clientCount, 1);

      final invoices = await InvoicesRepository().loadInvoices();
      expect(invoices.single.number, '2026-0001');
      final clients = await ClientsRepository().loadClients();
      expect(clients.single.name, 'Acme');
      final business = await BusinessProfileRepository().loadProfile();
      expect(business?.name, 'Santiago');
      final template = await EmailTemplateRepository().loadTemplate();
      expect(template?.subject, 'Hi');
    });

    test('restore rejects invalid documents', () async {
      await expectLater(
        _service().restoreFromJson('{"nope": true}'),
        throwsFormatException,
      );
      await expectLater(
        _service().restoreFromJson('not json at all'),
        throwsA(isA<FormatException>()),
      );
    });

    test('CSV export lists invoices with tax totals', () async {
      await InvoicesRepository().saveInvoices([_invoice()]);
      final file = await _service().writeInvoicesCsv(
        headers: const [
          'Number',
          'Client',
          'Issue date',
          'Due date',
          'Status',
          'Subtotal',
          'TPS',
          'TVQ',
          'Total',
        ],
        statusLabels: {for (var s in InvoiceStatus.values) s: 'X'},
        clientNames: const {'c1': 'Acme inc.'},
      );
      final content = await file.readAsString();
      final lines = content.replaceFirst('\uFEFF', '').split('\r\n');
      expect(lines.first,
          'Number;Client;Issue date;Due date;Status;Subtotal;TPS;TVQ;Total');
      // 2 x $50 taxed: $100.00 + $5.00 TPS + $10.47 TVQ = $115.47.
      expect(
        lines[1],
        '2026-0001;Acme inc.;2026-09-25;2026-10-25;X;100.00;5.00;10.47;115.47',
      );
    });

    test('CSV export quotes cells containing separators', () async {
      await InvoicesRepository().saveInvoices([_invoice()]);
      final file = await _service().writeInvoicesCsv(
        headers: const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i'],
        statusLabels: {for (var s in InvoiceStatus.values) s: 'X'},
        clientNames: const {'c1': 'Acme; "Les" Amis'},
      );
      final content = await file.readAsString();
      expect(content, contains('"Acme; ""Les"" Amis"'));
    });
  });
}
