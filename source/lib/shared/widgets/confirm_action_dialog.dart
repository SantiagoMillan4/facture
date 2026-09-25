import 'package:flutter/cupertino.dart';

import '../../l10n/app_l10n.dart';
import 'package:flutter/material.dart';

/// Shows a platform-appropriate confirmation dialog.
///
/// - iOS/macOS: [CupertinoAlertDialog]
/// - Android/other platforms: [AlertDialog]
///
/// Returns `true` when the user confirms, `false` when they cancel or
/// dismiss the dialog.
Future<bool> showConfirmActionDialog(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
  String? cancelLabel,
  bool destructive = true,
}) async {
  final l10n = context.l10n;
  final confirmText = confirmLabel ?? l10n.confirm;
  final cancelText = cancelLabel ?? l10n.dialogCancel;
  final platform = Theme.of(context).platform;

  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: destructive,
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: destructive
              ? TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                )
              : null,
          child: Text(confirmText),
        ),
      ],
    ),
  );

  return result ?? false;
}
