import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/confirm_action_dialog.dart';
import '../../../shared/widgets/form_section_title.dart';
import '../../business/application/business_profile_providers.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../clients/application/clients_providers.dart';
import '../../email/application/email_template_providers.dart';
import '../../invoices/application/invoices_providers.dart';
import '../../invoices/domain/invoice.dart';
import '../application/backup_providers.dart';

/// Backup & export tool: JSON backup of the whole database (export +
/// import/restore) and a CSV invoice export for the accountant.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  bool _busy = false;

  Future<void> _exportBackup() async {
    setState(() => _busy = true);
    try {
      final file = await ref.read(backupServiceProvider).writeBackupFile();
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv() async {
    setState(() => _busy = true);
    try {
      final l10n = context.l10n;
      final clients = await ref.read(clientsProvider.future);
      final file = await ref.read(backupServiceProvider).writeInvoicesCsv(
            headers: [
              l10n.csvNumber,
              l10n.csvClient,
              l10n.csvIssueDate,
              l10n.csvDueDate,
              l10n.csvStatus,
              l10n.csvSubtotal,
              l10n.csvTps,
              l10n.csvTvq,
              l10n.csvTotal,
            ],
            statusLabels: {
              InvoiceStatus.draft: l10n.statusDraft,
              InvoiceStatus.sent: l10n.statusSent,
              InvoiceStatus.paid: l10n.statusPaid,
              InvoiceStatus.overdue: l10n.statusOverdue,
            },
            clientNames: {for (final c in clients) c.id: c.name},
          );
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _importBackup() async {
    final l10n = context.l10n;
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    final file = picked.firstOrNull;
    if (file == null || !mounted) return;
    final String raw;
    try {
      if (file.path != null) {
        raw = await File(file.path!).readAsString();
      } else {
        raw = utf8.decode(await file.xFile.readAsBytes());
      }
    } catch (_) {
      _snack(l10n.backupInvalid);
      return;
    }
    final confirmed = await showConfirmActionDialog(
      context,
      title: l10n.backupImportConfirmTitle,
      message: l10n.backupImportConfirmMessage,
      confirmLabel: l10n.backupImportConfirmAction,
    );
    if (!confirmed || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(backupServiceProvider).restoreFromJson(raw);
      ref
        ..invalidate(invoicesProvider)
        ..invalidate(clientsProvider)
        ..invalidate(businessProfileProvider)
        ..invalidate(emailTemplateProvider)
        ..invalidate(catalogItemsProvider);
      _snack(context.l10n.backupRestored);
    } on FormatException {
      _snack(context.l10n.backupInvalid);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(l10n.backupExplainer, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          FormSectionTitle(title: l10n.backupSection),
          _BackupTile(
            icon: Icons.upload_outlined,
            title: l10n.backupExport,
            subtitle: l10n.backupExportSubtitle,
            busy: _busy,
            onTap: _exportBackup,
          ),
          _BackupTile(
            icon: Icons.download_outlined,
            title: l10n.backupImport,
            subtitle: l10n.backupImportSubtitle,
            busy: _busy,
            onTap: _importBackup,
          ),
          const SizedBox(height: AppSpacing.lg),
          FormSectionTitle(title: l10n.backupExportSection),
          _BackupTile(
            icon: Icons.table_chart_outlined,
            title: l10n.backupCsv,
            subtitle: l10n.backupCsvSubtitle,
            busy: _busy,
            onTap: _exportCsv,
          ),
          if (_busy) ...[
            const SizedBox(height: AppSpacing.lg),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.busy,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        enabled: !busy,
        onTap: onTap,
      ),
    );
  }
}
