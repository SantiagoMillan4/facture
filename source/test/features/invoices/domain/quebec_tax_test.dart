import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/domain/quebec_tax.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('quebec_tax', () {
    test('canonical \$100 line: TPS 5.00, TVQ 10.47, total 115.47', () {
      final line = taxesForLine(10000);

      expect(line.subtotalCents, 10000);
      expect(line.tpsCents, 500);
      expect(line.tvqCents, 1047);
      expect(line.totalCents, 11547);
    });

    test('TVQ is computed on subtotal INCLUDING TPS (tax on tax)', () {
      // 9.975% of the bare $100 subtotal would round to 998c (997.5c).
      // The Québec rule taxes $105 instead, giving 1047c.
      final line = taxesForLine(10000);

      expect(line.tvqCents, 1047);
      expect(line.tvqCents, isNot(998));
    });

    test('taxes round per line, not once on the invoice total', () {
      // Two 5c lines at 10% TVQ: 0.5c per line rounds UP per line (1c+1c),
      // while 10% of the 10c total would round to a single 1c.
      const rates = QuebecTaxRates(tpsPercent: 0, tvqPercent: 10);
      final invoice = taxesForInvoice([5, 5], rates: rates);

      expect(invoice.tvqCents, 2);
      expect(invoice.totalCents, 12);
    });

    test('half cents round away from zero', () {
      const rates = QuebecTaxRates(tpsPercent: 0, tvqPercent: 10);

      expect(taxesForLine(5, rates: rates).tvqCents, 1); // 0.5c -> 1c
      expect(taxesForLine(4, rates: rates).tvqCents, 0); // 0.4c -> 0c
    });

    test('zero subtotal yields zero taxes', () {
      final line = taxesForLine(0);

      expect(line.tpsCents, 0);
      expect(line.tvqCents, 0);
      expect(line.totalCents, 0);
    });

    test('small supplier (chargeTaxes false) charges no tax', () {
      final invoice = taxesForInvoice([10000, 2550], chargeTaxes: false);

      expect(invoice.subtotalCents, 12550);
      expect(invoice.tpsCents, 0);
      expect(invoice.tvqCents, 0);
      expect(invoice.totalCents, 12550);
    });

    test('negative lines (discounts) mirror positive lines', () {
      final line = taxesForLine(-10000);

      expect(line.tpsCents, -500);
      expect(line.tvqCents, -1047);
      expect(line.totalCents, -11547);
    });

    test('rates are user-editable', () {
      const noTvq = QuebecTaxRates(tpsPercent: 5, tvqPercent: 0);
      final line = taxesForLine(10000, rates: noTvq);

      expect(line.tpsCents, 500);
      expect(line.tvqCents, 0);
      expect(line.totalCents, 10500);
    });

    test('empty invoice has zero totals', () {
      final invoice = taxesForInvoice(const []);

      expect(invoice.subtotalCents, 0);
      expect(invoice.tpsCents, 0);
      expect(invoice.tvqCents, 0);
      expect(invoice.totalCents, 0);
    });
  });

  group('dollarsToCents', () {
    test('converts at cent precision', () {
      expect(dollarsToCents(19.99), 1999);
      expect(dollarsToCents(100.0), 10000);
      expect(dollarsToCents(0.0), 0);
    });

    test('centsToDollars round-trips', () {
      expect(centsToDollars(11547), 115.47);
    });
  });

  group('Invoice.taxes', () {
    Invoice invoice() => Invoice(
          id: 'inv-1',
          number: '2026-001',
          clientId: 'client-1',
          issueDate: DateTime(2026, 9, 25),
          dueDate: DateTime(2026, 10, 25),
          lines: const [
            // 2 x $50.00 = $100.00 -> TPS 500c, TVQ 1047c
            InvoiceLineItem(
              id: 'l1',
              description: 'Design',
              quantity: 2,
              unitPrice: 50.0,
            ),
            // 1 x $25.50 = $25.50 -> TPS 128c, TVQ 267c
            InvoiceLineItem(
              id: 'l2',
              description: 'Hosting',
              quantity: 1,
              unitPrice: 25.5,
            ),
          ],
        );

    test('derives subtotal, TPS, TVQ and total from lines', () {
      final taxes = invoice().taxes(chargeTaxes: true);

      expect(taxes.subtotalCents, 12550);
      expect(taxes.tpsCents, 628);
      expect(taxes.tvqCents, 1314);
      expect(taxes.totalCents, 14492);
    });

    test('small supplier invoice carries no tax', () {
      final taxes = invoice().taxes(chargeTaxes: false);

      expect(taxes.subtotalCents, 12550);
      expect(taxes.tpsCents, 0);
      expect(taxes.tvqCents, 0);
      expect(taxes.totalCents, 12550);
    });
  });

  group('extractTaxes (tax-included total -> pre-tax subtotal)', () {
    test('recovers the textbook example', () {
      final recovered = extractTaxes(11547);

      expect(recovered.subtotalCents, 10000);
      expect(recovered.tpsCents, 500);
      expect(recovered.tvqCents, 1047);
      expect(recovered.totalCents, 11547);
    });

    test('zero total recovers zero', () {
      final recovered = extractTaxes(0);

      expect(recovered.subtotalCents, 0);
      expect(recovered.tpsCents, 0);
      expect(recovered.tvqCents, 0);
    });

    test('round-trips every forward total', () {
      // The forward map is strictly increasing (each pre-tax cent adds at
      // least one total cent), so every achievable total inverts exactly.
      for (final subtotal in [1, 2, 99, 100, 199, 999, 1000, 9999, 100000]) {
        final total = taxesForLine(subtotal).totalCents;
        final recovered = extractTaxes(total);

        expect(
          recovered.subtotalCents,
          subtotal,
          reason: 'total $total should invert to subtotal $subtotal',
        );
      }
    });

    test('respects custom rates', () {
      const rates = QuebecTaxRates(tpsPercent: 5.0, tvqPercent: 0.0);
      final forward = taxesForLine(20000, rates: rates);
      final recovered = extractTaxes(forward.totalCents, rates: rates);

      expect(recovered.subtotalCents, 20000);
      expect(recovered.tpsCents, 1000);
      expect(recovered.tvqCents, 0);
    });
  });
}
