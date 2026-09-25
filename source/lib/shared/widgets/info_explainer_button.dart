import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../theme/app_spacing.dart';

/// An info icon that opens a bottom sheet explaining a concept.
///
/// Used next to investor metrics (DSCR, cap rate, ...) and anywhere a
/// short plain-language explanation helps.
class InfoExplainerButton extends StatelessWidget {
  const InfoExplainerButton({
    super.key,
    required this.title,
    required this.body,
    this.icon = Icons.info_outline,
  });

  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.whatIs(title),
      visualDensity: VisualDensity.compact,
      onPressed: () =>
          showInfoExplainerSheet(context, title: title, body: body),
      icon: Icon(icon, size: 18),
    );
  }
}

/// Opens a bottom sheet with a plain-language explanation.
Future<void> showInfoExplainerSheet(
  BuildContext context, {
  required String title,
  required String body,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final theme = Theme.of(context);
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xxxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(body, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      );
    },
  );
}
