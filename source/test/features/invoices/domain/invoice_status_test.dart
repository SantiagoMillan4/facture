import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Invoice.allowedTransitions', () {
    test('draft can be sent or marked paid', () {
      expect(
        Invoice.allowedTransitions(InvoiceStatus.draft),
        [InvoiceStatus.sent, InvoiceStatus.paid],
      );
    });

    test('sent can be paid or returned to draft', () {
      expect(
        Invoice.allowedTransitions(InvoiceStatus.sent),
        [InvoiceStatus.paid, InvoiceStatus.draft],
      );
    });

    test('overdue shares sent transitions (it is derived, never a target)',
        () {
      expect(
        Invoice.allowedTransitions(InvoiceStatus.overdue),
        [InvoiceStatus.paid, InvoiceStatus.draft],
      );
    });

    test('paid can be reopened as sent or returned to draft', () {
      expect(
        Invoice.allowedTransitions(InvoiceStatus.paid),
        [InvoiceStatus.sent, InvoiceStatus.draft],
      );
    });
  });

  group('sentDate persistence', () {
    Invoice base() => Invoice(
          id: 'i1',
          number: '2026-0001',
          clientId: 'c1',
          issueDate: DateTime(2026, 9, 1),
          dueDate: DateTime(2026, 10, 1),
          status: InvoiceStatus.sent,
        );

    test('round-trips through JSON', () {
      final invoice = base().copyWith(sentDate: DateTime(2026, 9, 2, 10, 30));

      final restored = Invoice.fromJson(invoice.toJson());

      expect(restored.sentDate, invoice.sentDate);
      expect(restored, invoice);
    });

    test('missing sentDate (old invoices) reads as null', () {
      final json = Map<String, dynamic>.from(base().toJson())
        ..remove('sentDate');

      expect(Invoice.fromJson(json).sentDate, isNull);
    });

    test('equality includes sentDate', () {
      final a = base().copyWith(sentDate: DateTime(2026, 9, 2));
      final b = base().copyWith(sentDate: DateTime(2026, 9, 3));

      expect(a == b, isFalse);
    });
  });
}
