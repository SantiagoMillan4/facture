import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';

/// One option in [showAdaptiveActionSheet].
class ActionSheetOption<T> {
  const ActionSheetOption({
    required this.value,
    required this.label,
    this.icon,
    this.destructive = false,
  });

  final T value;
  final String label;
  final IconData? icon;
  final bool destructive;
}

/// Shows a platform-appropriate action sheet and returns the selected
/// option's value, or null when dismissed.
///
/// - iOS/macOS: [CupertinoActionSheet] via [showCupertinoModalPopup].
/// - Android/other: [showModalBottomSheet] with a plain option list.
Future<T?> showAdaptiveActionSheet<T>(
  BuildContext context, {
  required String title,
  String? message,
  required List<ActionSheetOption<T>> options,
  String? cancelLabel,
}) async {
  final platform = Theme.of(context).platform;
  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(title),
        message: message == null ? null : Text(message),
        actions: [
          for (final option in options)
            CupertinoActionSheetAction(
              isDestructiveAction: option.destructive,
              onPressed: () => Navigator.of(context).pop(option.value),
              child: Text(option.label),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(cancelLabel ?? context.l10n.dialogCancel),
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          for (final option in options)
            ListTile(
              leading: option.icon == null
                  ? null
                  : Icon(
                      option.icon,
                      color: option.destructive
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
              title: Text(
                option.label,
                style: TextStyle(
                  color: option.destructive
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
              onTap: () => Navigator.of(context).pop(option.value),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
