import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/widgets/app_page_route.dart';
import '../../../shared/widgets/empty_state.dart';
import 'create_invoice_screen.dart';

/// Invoice list — the app's main feature tab.
///
/// TODO: Riverpod invoice list (draft/sent/paid/overdue), search/filter.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  void _openCreate(BuildContext context) {
    pushAppPage(context, (_) => const CreateInvoiceScreen());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.invoicesTitle)),
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
