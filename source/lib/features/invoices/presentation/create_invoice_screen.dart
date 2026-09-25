import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';

/// New-invoice flow — scaffold placeholder.
///
/// TODO: client picker, line-item editor with live TPS/TVQ totals
/// (quebec_tax.dart), issue/due dates, notes, save as draft.
class CreateInvoiceScreen extends StatelessWidget {
  const CreateInvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.newInvoice),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('TODO: client, lines, taxes, dates, save'),
      ),
    );
  }
}
