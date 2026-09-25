import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/pdf/invoice_pdf.dart';
import 'package:flutter_test/flutter_test.dart';

Invoice _invoice({bool chargeTaxes = true}) => Invoice(
  id: 'i1',
  number: '2026-0001',
  clientId: 'c1',
  issueDate: DateTime(2026, 9, 1),
  dueDate: DateTime(2026, 10, 1),
  lines: const [
    InvoiceLineItem(
      id: 'l1',
      description: 'Design work',
      quantity: 2,
      unitPrice: 100,
    ),
  ],
  status: InvoiceStatus.sent,
  notes: 'Merci!',
  chargeTaxes: chargeTaxes,
);

const _client = Client(
  id: 'c1',
  name: 'Client Inc.',
  email: 'client@example.com',
);

void main() {
  group('buildInvoicePdf', () {
    test('generates non-empty PDF (French, with taxes)', () async {
      final bytes = await buildInvoicePdf(
        invoice: _invoice(),
        client: _client,
        profile: const BusinessProfile(
          name: 'Atelier Nord',
          tpsNumber: '123456789RT0001',
          tvqNumber: '1234567890TQ0001',
        ),
        french: true,
      );
      expect(bytes, isNotEmpty);
      // PDF magic header.
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('generates non-empty PDF (English, no taxes, no profile)', () async {
      final bytes = await buildInvoicePdf(
        invoice: _invoice(chargeTaxes: false),
        client: _client,
        profile: null,
        french: false,
      );
      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('handles paid status and empty notes', () async {
      final bytes = await buildInvoicePdf(
        invoice: _invoice().copyWith(
          status: InvoiceStatus.paid,
          paidDate: DateTime(2026, 9, 15),
          notes: '',
        ),
        client: const Client(id: 'c1', name: 'Client Inc.'),
        profile: const BusinessProfile(name: 'Atelier Nord'),
        french: true,
      );
      expect(bytes, isNotEmpty);
    });
  });
}
