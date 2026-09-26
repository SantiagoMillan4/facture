import 'dart:convert';
import 'dart:io';

import '../../business/data/business_profile_repository.dart';
import '../../business/domain/business_profile.dart';
import '../../clients/data/clients_repository.dart';
import '../../clients/domain/client.dart';
import '../../email/data/email_template_repository.dart';
import '../../email/domain/email_template.dart';
import '../../invoices/data/invoices_repository.dart';
import '../../invoices/domain/invoice.dart';
import '../../invoices/domain/quebec_tax.dart';
import '../domain/backup_payload.dart';

/// How many records a backup restore wrote.
class RestoreSummary {
  const RestoreSummary({required this.invoiceCount, required this.clientCount});

  final int invoiceCount;
  final int clientCount;
}

/// Reads and writes full-database backups and invoice CSV exports.
///
/// File sharing itself stays in the presentation layer (share_plus); this
/// service only produces the files and restores from parsed JSON.
class BackupService {
  BackupService({
    required this.invoices,
    required this.clients,
    required this.business,
    required this.email,
  });

  final InvoicesRepository invoices;
  final ClientsRepository clients;
  final BusinessProfileRepository business;
  final EmailTemplateRepository email;

  /// Writes the whole local database to a JSON backup file in the temp
  /// directory and returns it.
  Future<File> writeBackupFile() async {
    final savedInvoices = await invoices.loadInvoices();
    final savedClients = await clients.loadClients();
    final savedBusiness = await business.loadProfile();
    final savedEmail = await email.loadTemplate();
    final payload = BackupPayload(
      exportedAt: DateTime.now(),
      invoices: savedInvoices.map((i) => i.toJson()).toList(),
      clients: savedClients.map((c) => c.toJson()).toList(),
      businessProfile: savedBusiness?.toJson(),
      emailTemplate: savedEmail?.toJson(),
    );
    final file = await _tempFile('facture-backup', 'json');
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload.toJson()),
    );
    return file;
  }

  /// Validates [raw] as a Facture backup and overwrites every store with
  /// its contents. Throws [FormatException] on invalid documents.
  Future<RestoreSummary> restoreFromJson(String raw) async {
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Not a Facture backup file.');
    }
    final payload = BackupPayload.parse(decoded);
    final restoredInvoices =
        payload.invoices.map(Invoice.fromJson).toList(growable: false);
    final restoredClients =
        payload.clients.map(Client.fromJson).toList(growable: false);
    await invoices.saveInvoices(restoredInvoices);
    await clients.saveClients(restoredClients);
    final businessJson = payload.businessProfile;
    if (businessJson != null) {
      await business.saveProfile(BusinessProfile.fromJson(businessJson));
    }
    final emailJson = payload.emailTemplate;
    if (emailJson != null) {
      await email.saveTemplate(EmailTemplate.fromJson(emailJson));
    }
    return RestoreSummary(
      invoiceCount: restoredInvoices.length,
      clientCount: restoredClients.length,
    );
  }

  /// Writes one row per invoice for the accountant. Semicolon-separated
  /// so French Excel opens it with one column per field.
  Future<File> writeInvoicesCsv({
    required List<String> headers,
    required Map<InvoiceStatus, String> statusLabels,
    required Map<String, String> clientNames,
  }) async {
    assert(headers.length == 9);
    final savedInvoices = await invoices.loadInvoices()
      ..sort((a, b) => b.issueDate.compareTo(a.issueDate));
    final lines = <String>[headers.map(_csvCell).join(';')];
    for (final invoice in savedInvoices) {
      final taxes = invoice.taxes();
      lines.add(<String>[
        invoice.number,
        clientNames[invoice.clientId] ?? '',
        _date(invoice.issueDate),
        _date(invoice.dueDate),
        statusLabels[invoice.effectiveStatus] ?? invoice.status.name,
        _dollars(dollarsToCents(invoice.subtotal)),
        _dollars(taxes.tpsCents),
        _dollars(taxes.tvqCents),
        _dollars(taxes.totalCents),
      ].map(_csvCell).join(';'));
    }
    final file = await _tempFile('facture-invoices', 'csv');
    // BOM so Excel detects UTF-8 (accents in client names).
    await file.writeAsString('\uFEFF${lines.join('\r\n')}');
    return file;
  }

  Future<File> _tempFile(String prefix, String extension) async {
    final stamp = DateTime.now().toIso8601String().split('T').first;
    final dir = await Directory.systemTemp.createTemp('facture');
    return File('${dir.path}/$prefix-$stamp.$extension');
  }

  static String _csvCell(String value) {
    if (value.contains(';') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  static String _date(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  static String _dollars(int cents) => (cents / 100).toStringAsFixed(2);
}
