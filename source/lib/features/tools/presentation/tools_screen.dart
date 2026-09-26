import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../backup/presentation/backup_screen.dart';
import '../../catalog/presentation/catalog_screen.dart';
import '../../email/presentation/email_template_screen.dart';
import 'tax_calculator_screen.dart';

/// Tools tab: the freelancer's utility drawer. Each tool opens its own
/// screen; new tools (item catalog, backup & export, logo) land here.
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navTools)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          _ToolTile(
            icon: Icons.calculate_outlined,
            title: l10n.toolsTaxCalculator,
            subtitle: l10n.toolsTaxCalculatorSubtitle,
            onTap: () =>
                pushAppPage(context, (_) => const TaxCalculatorScreen()),
          ),
          _ToolTile(
            icon: Icons.mail_outline,
            title: l10n.emailTemplateTitle,
            subtitle: l10n.emailTemplateSubtitle,
            onTap: () =>
                pushAppPage(context, (_) => const EmailTemplateScreen()),
          ),
          _ToolTile(
            icon: Icons.backup_outlined,
            title: l10n.backupTitle,
            subtitle: l10n.backupSubtitle,
            onTap: () => pushAppPage(context, (_) => const BackupScreen()),
          ),
          _ToolTile(
            icon: Icons.inventory_2_outlined,
            title: l10n.catalogTitle,
            subtitle: l10n.catalogSubtitle,
            onTap: () => pushAppPage(context, (_) => const CatalogScreen()),
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
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
        onTap: onTap,
      ),
    );
  }
}
