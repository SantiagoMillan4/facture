import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../l10n/app_l10n.dart';
import '../../../shared/theme/app_spacing.dart';

/// Live preview of the logo being created: the rendered PNG on a neutral
/// tile, a spinner while rendering, or a hint when there is no name yet.
class LogoPreview extends StatelessWidget {
  const LogoPreview({super.key, required this.bytes, required this.rendering});

  final Uint8List? bytes;
  final bool rendering;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final imageBytes = bytes;
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: rendering
            ? const CircularProgressIndicator()
            : imageBytes == null
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.logoCreatorEmptyName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Image.memory(imageBytes, fit: BoxFit.contain),
              ),
      ),
    );
  }
}
