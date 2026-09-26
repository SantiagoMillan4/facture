import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../business/application/business_profile_providers.dart';
import '../../clients/domain/client.dart';
import '../../invoices/domain/invoice.dart';
import '../../invoices/domain/quebec_tax.dart';
import '../../invoices/pdf/share_invoice_pdf.dart';
import '../domain/email_template.dart';
import 'email_template_providers.dart';

/// Emails the invoice with its PDF attached.
///
/// Renders the user's template (or the localized default) with the invoice's
/// data, then opens the native share sheet with the PDF attached and the
/// rendered subject/message prefilled — the user picks Mail, Gmail, Outlook
/// or anything else, and addresses it to the client.
///
/// This goes through the share sheet instead of a `mailto:` link because
/// `mailto:` cannot carry attachments on iOS.
Future<void> shareInvoiceEmail({
  required BuildContext context,
  required WidgetRef ref,
  required Invoice invoice,
  required Client client,
}) async {
  final french = context.isFrench;
  final template =
      ref.read(emailTemplateProvider).value ??
      EmailTemplate.defaults(french: french);
  final profile = ref.read(businessProfileProvider).value;
  final amount = formatCurrencyWithCents(
    centsToDollars(invoice.taxes().totalCents),
    french: french,
  );
  final values = EmailTemplate.values(
    invoiceNumber: invoice.number,
    clientName: client.name,
    amount: amount,
    dueDate: _isoDate(invoice.dueDate),
    issueDate: _isoDate(invoice.issueDate),
    businessName: profile?.name ?? '',
  );

  AppHaptics.confirm();
  await shareInvoicePdf(
    invoice: invoice,
    client: client,
    profile: profile,
    l10n: context.l10n,
    subject: EmailTemplate.render(template.subject, values),
    text: EmailTemplate.render(template.body, values),
  );
}

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
