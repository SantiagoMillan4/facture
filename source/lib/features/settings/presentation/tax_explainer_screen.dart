import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';

/// Plain-language explainer for the Québec sales-tax rules the app applies.
///
/// Mirrors the exact rules in `quebec_tax.dart` — if the math ever changes,
/// this text changes with it.
class TaxExplainerScreen extends StatelessWidget {
  const TaxExplainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tpsTvqTitle)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          for (final paragraph in [
            l10n.tpsTvqBody1,
            l10n.tpsTvqBody2,
            l10n.tpsTvqBody3,
          ])
            Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  paragraph,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
