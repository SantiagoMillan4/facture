import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/pdf/invoice_pdf.dart';
import 'dart:typed_data';

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

/// A minimal 1x1 transparent PNG, valid for the PDF image decoder.
final _tinyPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

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

    test('renders the business logo in the header when provided', () async {
      final withLogo = await buildInvoicePdf(
        invoice: _invoice(),
        client: _client,
        profile: const BusinessProfile(name: 'Atelier Nord'),
        french: true,
        logoBytes: _tinyPng,
      );
      final withoutLogo = await buildInvoicePdf(
        invoice: _invoice(),
        client: _client,
        profile: const BusinessProfile(name: 'Atelier Nord'),
        french: true,
      );
      expect(withLogo, isNotEmpty);
      // The embedded image makes the logo'd PDF larger.
      expect(withLogo.length, greaterThan(withoutLogo.length));
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
