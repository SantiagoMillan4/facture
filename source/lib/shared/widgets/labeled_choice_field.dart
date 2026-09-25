import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// A single option in a [LabeledChoiceField].
class ChoiceOption<T> {
  const ChoiceOption({required this.value, required this.label, this.sublabel});

  final T value;
  final String label;
  final String? sublabel;
}

/// A labeled single-choice control rendered as a segmented button.
///
/// Best for two or three short options. Each option has a [value], a short
/// [label], and an optional [sublabel] shown underneath for extra clarity
/// (e.g. "Canada" / "Semi-annual compounding").
class LabeledChoiceField<T> extends StatelessWidget {
  const LabeledChoiceField({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.helper,
  });

  final String label;
  final List<ChoiceOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.xs),
          SegmentedButton<T>(
            segments: [
              for (final option in options)
                ButtonSegment<T>(
                  value: option.value,
                  label: option.sublabel == null
                      ? Text(option.label)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(option.label),
                            Text(
                              option.sublabel!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                ),
            ],
            selected: {selected},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
          if (helper != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              helper!,
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
