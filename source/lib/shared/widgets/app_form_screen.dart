import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';
import '../theme/app_spacing.dart';
import 'app_haptics.dart';

/// A reusable full-screen form experience.
///
/// The form content is provided by [child], while this widget handles:
/// - platform-appropriate navigation
/// - scrolling
/// - keyboard avoidance
/// - save/loading state
/// - consistent spacing
///
/// Use this for creation/editing flows such as properties, scenarios,
/// income, and expenses.
class AppFormScreen extends StatelessWidget {
  const AppFormScreen({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
    this.saveLabel,
    this.isSaving = false,
    this.subtitle,
  });

  final String title;
  final Widget child;
  final Future<void> Function() onSave;
  final String? saveLabel;
  final bool isSaving;
  final String? subtitle;

  /// Runs the save and confirms with a subtle haptic on success.
  Future<void> _handleSave() async {
    await onSave();
    AppHaptics.confirm();
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final resolvedSaveLabel = saveLabel ?? context.l10n.dialogSave;

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      // Match the scaffold background explicitly: the default Cupertino bar
      // color is a system color that looks white-ish against our themed
      // scaffold when content scrolls underneath.
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(),
          middle: Text(title),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isSaving ? null : () => Navigator.of(context).pop(),
            child: Text(context.l10n.dialogCancel),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: isSaving ? null : _handleSave,
            child: isSaving
                ? const CupertinoActivityIndicator()
                : Text(resolvedSaveLabel),
          ),
        ),
        child: SafeArea(
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _FormBody(title: title, subtitle: subtitle, child: child),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          tooltip: context.l10n.dialogCancel,
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          TextButton(
            onPressed: isSaving ? null : _handleSave,
            child: isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(resolvedSaveLabel),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: _FormBody(title: title, subtitle: subtitle, child: child),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({required this.title, required this.child, this.subtitle});

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: AppSpacing.screenPadding,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxl),
          child,
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}

/// Opens [AppFormScreen] using a platform-appropriate page transition.
Future<T?> showAppFormScreen<T>(
  BuildContext context, {
  required String title,
  required Widget child,
  required Future<void> Function() onSave,
  String saveLabel = 'Save',
  bool isSaving = false,
  String? subtitle,
}) {
  final platform = Theme.of(context).platform;

  final page = AppFormScreen(
    title: title,
    subtitle: subtitle,
    saveLabel: saveLabel,
    isSaving: isSaving,
    onSave: onSave,
    child: child,
  );

  if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
    return Navigator.of(
      context,
    ).push<T>(CupertinoPageRoute(builder: (_) => page));
  }

  return Navigator.of(context).push<T>(MaterialPageRoute(builder: (_) => page));
}
