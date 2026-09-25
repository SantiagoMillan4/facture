import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';

/// Standard vertical gap between fields inside a [CompactFormDialog] —
/// compact controls, but still clear separation between parameters.
const compactFieldGap = SizedBox(height: AppSpacing.lg);

/// Rounded, subtly-elevated appearance shared by [DropdownMenu]s used inside
/// [CompactFormDialog]s.
final compactDropdownMenuStyle = MenuStyle(
  elevation: const WidgetStatePropertyAll(3),
  shape: WidgetStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.menu)),
  ),
);

/// Compact [AlertDialog] chrome for financial data-entry forms (property,
/// scenario, income/expense, mortgage). Uses a denser input decoration than
/// the app default so the dialog stays small and, combined with
/// [AlertDialog.scrollable], the focused field and actions never end up
/// hidden behind the keyboard.
class CompactFormDialog extends StatelessWidget {
  const CompactFormDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
  });

  final Widget title;
  final Widget content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          // Dialog surfaces use surfaceContainerHigh, so give fields a
          // visibly distinct fill instead of blending into the background.
          fillColor: colorScheme.surfaceContainerHighest,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.input),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
      ),
      child: AlertDialog(
        scrollable: true,
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
        actionsPadding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        buttonPadding: const EdgeInsets.symmetric(horizontal: 6),
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}
