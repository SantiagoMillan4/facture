import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/widgets/empty_state.dart';

/// Invoice list — scaffold placeholder.
///
/// TODO: Riverpod invoice list (draft/sent/paid/overdue), "new invoice"
/// action, search/filter.
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.invoicesTitle)),
      body: EmptyState(
        icon: Icons.receipt_long_outlined,
        title: context.l10n.invoicesEmptyTitle,
        message: context.l10n.invoicesEmptySubtitle,
      ),
    );
  }
}
