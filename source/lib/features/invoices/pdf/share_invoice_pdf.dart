import 'dart:io';

import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../business/application/business_logo.dart';
import '../../business/domain/business_profile.dart';
import '../../clients/domain/client.dart';
import '../domain/invoice.dart';
import '../domain/quebec_tax.dart';
import 'invoice_pdf.dart';

/// Renders the invoice as a PDF into a temp file and returns it.
/// The temp file is left for the OS to reclaim; nothing is uploaded anywhere.
Future<File> writeInvoicePdfToTemp({
  required Invoice invoice,
  required Client client,
  required BusinessProfile? profile,
  required bool french,
}) async {
  final bytes = await buildInvoicePdf(
    invoice: invoice,
    client: client,
    profile: profile,
    french: french,
    logoBytes: await BusinessLogo.readBytes(profile?.logoPath),
  );
  final safeNumber = invoice.number.replaceAll(RegExp('[^A-Za-z0-9-_]'), '_');
  final file = File('${Directory.systemTemp.path}/facture-$safeNumber.pdf');
  await file.writeAsBytes(bytes);
  return file;
}

/// Renders the invoice as a PDF into a temp file and opens the native
/// share sheet with it attached. The temp file is left for the OS to
/// reclaim; nothing is uploaded anywhere.
Future<void> shareInvoicePdf({
  required Invoice invoice,
  required Client client,
  required BusinessProfile? profile,
  required AppLocalizations l10n,
}) async {
  final french = l10n.localeName == 'fr';
  final file = await writeInvoicePdfToTemp(
    invoice: invoice,
    client: client,
    profile: profile,
    french: french,
  );

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
      subject: l10n.shareInvoiceSubject(invoice.number),
      text: l10n.shareInvoiceText(invoice.number, total),
    ),
  );
}
