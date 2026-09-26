import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../shared/utils/currency_formatter.dart';
import '../../business/domain/business_profile.dart';
import '../../clients/domain/client.dart';
import '../domain/invoice.dart';
import '../domain/quebec_tax.dart';
import 'invoice_pdf_strings.dart';

/// Builds a printable invoice PDF (A4) as bytes.
///
/// Layout: business header, invoice meta (number + dates), bill-to client
/// block, line-items table, TPS/TVQ totals, registration numbers when
/// taxes are charged, and notes. French or English throughout based on
/// [french]. Amounts reuse the app's Québec formatters.
Future<Uint8List> buildInvoicePdf({
  required Invoice invoice,
  required Client client,
  required BusinessProfile? profile,
  required bool french,
  Uint8List? logoBytes,
}) async {
  final doc = pw.Document();
  final t = InvoicePdfStrings(french);
  final dateFormat = _formatDate;
  String money(double amount) =>
      formatCurrencyWithCents(amount, french: french);

  final taxes = taxesForInvoice(
    invoice.lines.map((l) => dollarsToCents(l.subtotal)),
    chargeTaxes: invoice.chargeTaxes,
  );

  final headerStyle = pw.TextStyle(
    fontSize: 20,
    fontWeight: pw.FontWeight.bold,
  );
  final titleStyle = pw.TextStyle(
    fontSize: 26,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.blueGrey800,
  );
  final smallGrey = pw.TextStyle(fontSize: 10, color: PdfColors.blueGrey600);
  const labelWidth = 150.0;

  pw.Widget metaRow(String label, String value) => pw.Row(
    children: [
      pw.SizedBox(
        width: labelWidth,
        child: pw.Text(label, style: smallGrey),
      ),
      pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
    ],
  );

  pw.Widget totalRow(String label, String value, {bool bold = false}) =>
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: bold ? 14 : 11,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header: business identity + invoice title.
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (logoBytes != null)
                      pw.Container(
                        width: 96,
                        height: 48,
                        margin: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Image(
                          pw.MemoryImage(logoBytes),
                          fit: pw.BoxFit.contain,
                          alignment: pw.Alignment.centerLeft,
                        ),
                      ),
                    if (profile != null && profile.name.isNotEmpty)
                      pw.Text(profile.name, style: headerStyle),
                    if (profile != null && profile.address.isNotEmpty)
                      pw.Text(profile.address, style: smallGrey),
                    if (profile != null && profile.phone.isNotEmpty)
                      pw.Text(profile.phone, style: smallGrey),
                    if (profile != null && profile.email.isNotEmpty)
                      pw.Text(profile.email, style: smallGrey),
                  ],
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(t.invoiceTitle, style: titleStyle),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    invoice.number,
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          metaRow(t.issueDate, dateFormat(invoice.issueDate)),
          metaRow(t.dueDate, dateFormat(invoice.dueDate)),
          if (invoice.status == InvoiceStatus.paid)
            metaRow(
              t.paidOn,
              dateFormat(invoice.paidDate ?? invoice.issueDate),
            ),
          pw.SizedBox(height: 20),

          // Bill-to block.
          pw.Text(
            t.billTo,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey600,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            client.name,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          if (client.address.isNotEmpty)
            pw.Text(client.address, style: const pw.TextStyle(fontSize: 11)),
          if (client.email.isNotEmpty)
            pw.Text(client.email, style: const pw.TextStyle(fontSize: 11)),
          if (client.phone.isNotEmpty)
            pw.Text(client.phone, style: const pw.TextStyle(fontSize: 11)),
          pw.SizedBox(height: 20),

          // Line items.
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(
                color: PdfColors.blueGrey100,
              ),
              bottom: pw.BorderSide(color: PdfColors.blueGrey300),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(3),
              3: const pw.FlexColumnWidth(3),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.blueGrey50,
                ),
                children: [
                  for (final h in [
                    t.description,
                    t.quantity,
                    t.unitPrice,
                    t.amount,
                  ])
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 6,
                      ),
                      child: pw.Text(
                        h,
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueGrey700,
                        ),
                      ),
                    ),
                ],
              ),
              for (final line in invoice.lines)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 6,
                      ),
                      child: pw.Text(
                        line.description,
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 6,
                      ),
                      child: pw.Text(
                        _formatQty(line.quantity),
                        style: const pw.TextStyle(fontSize: 11),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 6,
                      ),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          money(line.unitPrice),
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 6,
                      ),
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          money(line.subtotal),
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 16),

          // Totals, right-aligned.
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.SizedBox(
              width: 240,
              child: pw.Column(
                children: [
                  totalRow(t.subtotal, money(centsToDollars(taxes.subtotalCents))),
                  if (invoice.chargeTaxes) ...[
                    totalRow('TPS (5 %)', money(centsToDollars(taxes.tpsCents))),
                    totalRow(
                      'TVQ (9,975 %)',
                      money(centsToDollars(taxes.tvqCents)),
                    ),
                  ],
                  pw.Divider(color: PdfColors.blueGrey300),
                  totalRow(
                    t.total,
                    money(centsToDollars(taxes.totalCents)),
                    bold: true,
                  ),
                ],
              ),
            ),
          ),

          // Registration numbers on taxed invoices.
          if (invoice.chargeTaxes && profile != null && profile.hasTaxNumbers)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 12),
              child: pw.Text(
                [
                  if (profile.tpsNumber.trim().isNotEmpty)
                    'TPS : ${profile.tpsNumber.trim()}',
                  if (profile.tvqNumber.trim().isNotEmpty)
                    'TVQ : ${profile.tvqNumber.trim()}',
                ].join('    '),
                style: smallGrey,
              ),
            ),

          if (invoice.notes.trim().isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              t.notes,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey600,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              invoice.notes.trim(),
              style: const pw.TextStyle(fontSize: 11),
            ),
          ],
        ],
      ),
    ),
  );

  return doc.save();
}

String _formatQty(double qty) {
  final text = qty.toString();
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// Locale-independent ISO date (yyyy-MM-dd): unambiguous on invoices in
/// both languages, and keeps this pure-Dart builder free of intl's
/// locale-data initialization.
String _formatDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
