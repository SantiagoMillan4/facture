import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../settings/presentation/settings_screen.dart';
import 'create_invoice_screen.dart';

/// Invoice list — the app's home screen.
///
/// TODO: Riverpod invoice list (draft/sent/paid/overdue), search/filter.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  void _openCreate(BuildContext context) {
    pushAppPage(context, (_) => const CreateInvoiceScreen());
  }

  void _openSettings(BuildContext context) {
    pushAppPage(context, (_) => const SettingsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.invoicesTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTitle,
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: EmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.invoicesEmptyTitle,
        message: l10n.invoicesEmptySubtitle,
        actionLabel: l10n.newInvoice,
        onAction: () => _openCreate(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreate(context),
        tooltip: l10n.newInvoice,
        child: const Icon(Icons.add),
      ),
    );
  }
}
