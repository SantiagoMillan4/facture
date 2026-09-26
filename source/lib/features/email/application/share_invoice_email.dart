import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/utils/currency_formatter.dart';
import '../../../shared/widgets/app_haptics.dart';
import '../../../shared/widgets/confirm_action_dialog.dart';
import '../../business/application/business_profile_providers.dart';
import '../../clients/domain/client.dart';
import '../../clients/presentation/client_edit_screen.dart';
import '../../invoices/domain/invoice.dart';
import '../../invoices/domain/quebec_tax.dart';
import '../../invoices/pdf/share_invoice_pdf.dart';
import '../domain/email_template.dart';
import 'email_template_providers.dart';

/// Emails the invoice with its PDF attached through the native email
/// composer sheet (Apple's composer on iOS, a send intent on Android).
///
/// Renders the user's template (or the localized default) with the invoice's
/// data, prefills the client as the recipient, and attaches the invoice PDF.
/// The invoice doesn't need to be saved first.
///
/// If the client has no email address, a native dialog offers to open their
/// editor instead of opening an unaddressed composer.
Future<void> shareInvoiceEmail({
  required BuildContext context,
  required WidgetRef ref,
  required Invoice invoice,
  required Client client,
}) async {
  final l10n = context.l10n;
  final french = context.isFrench;

  if (client.email.trim().isEmpty) {
    final add = await showConfirmActionDialog(
      context,
      title: l10n.invoiceNoClientEmailTitle,
      message: l10n.invoiceNoClientEmailMessage(client.name),
      confirmLabel: l10n.invoiceNoClientEmailAdd,
      destructive: false,
    );
    if (add && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ClientEditScreen(client: client)),
      );
    }
    return;
  }

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
  final file = await writeInvoicePdfToTemp(
    invoice: invoice,
    client: client,
    profile: profile,
    french: french,
  );

  try {
    await FlutterEmailSender.send(
      Email(
        body: EmailTemplate.render(template.body, values),
        subject: EmailTemplate.render(template.subject, values),
        recipients: [client.email.trim()],
        attachmentPaths: [file.path],
        isHTML: false,
      ),
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invoiceEmailFailed)),
      );
    }
  }
}

String _isoDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
