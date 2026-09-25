import 'dart:convert';

import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:flutter_test/flutter_test.dart';

Invoice _invoice({
  String id = 'i1',
  String number = '2026-0001',
  bool chargeTaxes = true,
  InvoiceStatus status = InvoiceStatus.draft,
  DateTime? dueDate,
}) => Invoice(
  id: id,
  number: number,
  clientId: 'c1',
  issueDate: DateTime(2026, 9, 25),
  dueDate: dueDate ?? DateTime(2026, 10, 25),
  lines: const [
    InvoiceLineItem(
      id: 'l1',
      description: 'Design',
      quantity: 2,
      unitPrice: 50,
    ),
  ],
  status: status,
  notes: 'Thanks',
  chargeTaxes: chargeTaxes,
  paidDate: status == InvoiceStatus.paid ? DateTime(2026, 9, 26) : null,
);

void main() {
  group('Invoice JSON', () {
    test('round-trips through toJson/fromJson', () {
      final invoice = _invoice();
      final restored = Invoice.fromJson(
        jsonDecode(jsonEncode(invoice.toJson())) as Map<String, dynamic>,
      );
      expect(restored, invoice);
    });

    test('round-trips a tax-free invoice with a paid date', () {
      final invoice = _invoice(chargeTaxes: false, status: InvoiceStatus.paid);
      final restored = Invoice.fromJson(
        jsonDecode(jsonEncode(invoice.toJson())) as Map<String, dynamic>,
      );
      expect(restored.chargeTaxes, isFalse);
      expect(restored.paidDate, isNotNull);
      expect(restored, invoice);
    });

    test('line item round-trips and compares by value', () {
      const line = InvoiceLineItem(
        id: 'l1',
        description: 'Design',
        quantity: 2,
        unitPrice: 50,
      );
      final restored = InvoiceLineItem.fromJson(
        jsonDecode(jsonEncode(line.toJson())) as Map<String, dynamic>,
      );
      expect(restored, line);
      expect(restored.hashCode, line.hashCode);
    });

    test('fromJson tolerates missing and corrupt fields', () {
      final invoice = Invoice.fromJson({'id': 'x'});
      expect(invoice.number, '');
      expect(invoice.lines, isEmpty);
      expect(invoice.status, InvoiceStatus.draft);
      expect(invoice.chargeTaxes, isTrue);
      expect(invoice.paidDate, isNull);
    });

    test('fromJson ignores unknown status values', () {
      final invoice = Invoice.fromJson({'id': 'x', 'status': 'nope'});
      expect(invoice.status, InvoiceStatus.draft);
    });
  });

  group('Invoice taxes', () {
    test('derives the canonical 100 -> 115.47 breakdown', () {
      final taxes = _invoice().taxes();
      expect(taxes.subtotalCents, 10000);
      expect(taxes.tpsCents, 500);
      expect(taxes.tvqCents, 1047);
      expect(taxes.totalCents, 11547);
    });

    test('chargeTaxes false produces zero taxes', () {
      final taxes = _invoice(chargeTaxes: false).taxes();
      expect(taxes.tpsCents, 0);
      expect(taxes.tvqCents, 0);
      expect(taxes.totalCents, taxes.subtotalCents);
    });
  });

  group('effectiveStatus', () {
    test('sent invoice past due reads as overdue', () {
      final invoice = _invoice(
        status: InvoiceStatus.sent,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(invoice.effectiveStatus, InvoiceStatus.overdue);
    });

    test('sent invoice due today or later stays sent', () {
      final now = DateTime.now();
      expect(
        _invoice(status: InvoiceStatus.sent, dueDate: now).effectiveStatus,
        InvoiceStatus.sent,
      );
      expect(
        _invoice(
          status: InvoiceStatus.sent,
          dueDate: now.add(const Duration(days: 3)),
        ).effectiveStatus,
        InvoiceStatus.sent,
      );
    });

    test('draft and paid are never overdue', () {
      final past = DateTime.now().subtract(const Duration(days: 30));
      expect(
        _invoice(status: InvoiceStatus.draft, dueDate: past).effectiveStatus,
        InvoiceStatus.draft,
      );
      expect(
        _invoice(status: InvoiceStatus.paid, dueDate: past).effectiveStatus,
        InvoiceStatus.paid,
      );
    });
  });

  group('nextInvoiceNumber', () {
    test('starts at YYYY-0001 with no invoices', () {
      final year = DateTime.now().year;
      expect(nextInvoiceNumber([]), '$year-0001');
    });

    test('sequences from the highest number of the current year', () {
      final year = DateTime.now().year;
      final invoices = [
        _invoice(number: '$year-0001'),
        _invoice(id: 'i2', number: '$year-0007'),
      ];
      expect(nextInvoiceNumber(invoices), '$year-0008');
    });

    test('ignores other years and custom numbers', () {
      final year = DateTime.now().year;
      final invoices = [
        _invoice(number: '${year - 1}-0042'),
        _invoice(id: 'i2', number: 'custom'),
      ];
      expect(nextInvoiceNumber(invoices), '$year-0001');
    });
  });
}
