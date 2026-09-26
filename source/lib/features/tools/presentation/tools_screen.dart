import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../backup/presentation/backup_screen.dart';
import '../../business/application/business_profile_providers.dart';
import '../../catalog/presentation/catalog_screen.dart';
import '../../logo/presentation/logo_creator_screen.dart';
import 'tax_calculator_screen.dart';

/// Tools tab: the freelancer's utility drawer. Each tool opens its own
/// screen; new tools (item catalog, backup & export, logo) land here.
class ToolsScreen extends ConsumerWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileName = ref.watch(businessProfileProvider).value?.name ?? '';
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
          _ToolTile(
            icon: Icons.palette_outlined,
            title: l10n.toolsLogoCreator,
            subtitle: l10n.toolsLogoCreatorSubtitle,
            onTap: () => pushAppPage(
              context,
              (_) => LogoCreatorScreen(initialName: profileName),
            ),
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
