import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A titled section inside a form, e.g. "Details" or "Financing".
class FormSectionTitle extends StatelessWidget {
  const FormSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.isFirst = false,
  });

  final String title;
  final String? subtitle;

  /// When true the top padding is skipped so the first section sits closer
  /// to the screen subtitle, matching the form's normal rhythm.
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 0 : AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
