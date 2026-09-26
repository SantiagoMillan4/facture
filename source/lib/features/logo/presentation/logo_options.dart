import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';
import '../application/logo_generator.dart';

/// The logo customization controls: style picker (segmented) and accent
/// color swatches. Stateless; the owning screen holds the selection.
class LogoOptions extends StatelessWidget {
  const LogoOptions({
    super.key,
    required this.style,
    required this.colorIndex,
    required this.palette,
    required this.onStyleChanged,
    required this.onColorChanged,
  });

  final LogoStyle style;
  final int colorIndex;
  final List<Color> palette;
  final ValueChanged<LogoStyle> onStyleChanged;
  final ValueChanged<int> onColorChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final sectionStyle = theme.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w700,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.logoCreatorStyleLabel, style: sectionStyle),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<LogoStyle>(
          segments: [
            ButtonSegment(
              value: LogoStyle.monogramCircle,
              label: Text(l10n.logoCreatorStyleCircle),
            ),
            ButtonSegment(
              value: LogoStyle.monogramRoundedSquare,
              label: Text(l10n.logoCreatorStyleSquare),
            ),
            ButtonSegment(
              value: LogoStyle.wordmark,
              label: Text(l10n.logoCreatorStyleWordmark),
            ),
          ],
          selected: {style},
          onSelectionChanged: (selected) => onStyleChanged(selected.first),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(l10n.logoCreatorColorLabel, style: sectionStyle),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (var i = 0; i < palette.length; i++)
              _ColorSwatch(
                color: palette[i],
                selected: i == colorIndex,
                onTap: () => onColorChanged(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selected
              ? Border.all(color: theme.colorScheme.primary, width: 3)
              : null,
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}
