import 'package:facture/features/invoices/data/invoices_repository.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Invoice _invoice(String id, String number) => Invoice(
  id: id,
  number: number,
  clientId: 'c1',
  issueDate: DateTime(2026, 9, 25),
  dueDate: DateTime(2026, 10, 25),
  lines: const [
    InvoiceLineItem(id: 'l1', description: 'Design', quantity: 1, unitPrice: 100),
  ],
);

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('InvoicesRepository', () {
    test('loads empty when nothing is stored', () async {
      final repo = InvoicesRepository();
      expect(await repo.loadInvoices(), isEmpty);
    });

    test('round-trips invoices through storage', () async {
      final repo = InvoicesRepository();
      final invoices = [_invoice('i1', '2026-0001'), _invoice('i2', '2026-0002')];

      await repo.saveInvoices(invoices);
      final loaded = await repo.loadInvoices();

      expect(loaded, invoices);
    });

    test('persists edits and deletions', () async {
      final repo = InvoicesRepository();
      await repo.saveInvoices([_invoice('i1', '2026-0001')]);
      await repo.saveInvoices([_invoice('i1', '2026-0042')]);

      expect(await repo.loadInvoices(), [_invoice('i1', '2026-0042')]);
    });

    test('corrupted data loads as empty instead of crashing', () async {
      SharedPreferences.setMockInitialValues({
        InvoicesRepository.storageKey: 'not-json{{{',
      });
      final repo = InvoicesRepository();
      expect(await repo.loadInvoices(), isEmpty);
    });

    test('non-invoice JSON loads as empty', () async {
      SharedPreferences.setMockInitialValues({
        InvoicesRepository.storageKey: '{"oops": true}',
      });
      final repo = InvoicesRepository();
      expect(await repo.loadInvoices(), isEmpty);
    });
  });
}
