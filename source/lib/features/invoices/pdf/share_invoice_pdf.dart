import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../business/domain/business_profile.dart';
import '../../clients/domain/client.dart';
import '../domain/invoice.dart';
import '../domain/quebec_tax.dart';
import 'invoice_pdf.dart';

/// Renders the invoice as a PDF into a temp file and opens the native
/// share sheet with it attached. The temp file is left for the OS to
/// reclaim; nothing is uploaded anywhere.
///
/// [subject] and [text] override the default share message — used by the
/// email flow to prefill the rendered template. When omitted, a generic
/// invoice summary is shared.
Future<void> shareInvoicePdf({
  required Invoice invoice,
  required Client client,
  required BusinessProfile? profile,
  required AppLocalizations l10n,
  String? subject,
  String? text,
}) async {
  final french = l10n.localeName == 'fr';
  final bytes = await buildInvoicePdf(
    invoice: invoice,
    client: client,
    profile: profile,
    french: french,
  );
  final safeNumber = invoice.number.replaceAll(RegExp('[^A-Za-z0-9-_]'), '_');
  final file = File('${Directory.systemTemp.path}/facture-$safeNumber.pdf');
  await file.writeAsBytes(bytes);

  final taxes = taxesForInvoice(
    invoice.lines.map((l) => dollarsToCents(l.subtotal)),
    chargeTaxes: invoice.chargeTaxes,
  );
  final total = formatCurrencyWithCents(
    centsToDollars(taxes.totalCents),
    french: french,
  );

  await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path)],
      subject: subject ?? l10n.shareInvoiceSubject(invoice.number),
      text: text ?? l10n.shareInvoiceText(invoice.number, total),
    ),
  );
}
