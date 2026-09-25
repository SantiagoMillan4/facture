import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A single option in an [OptionPickerField].
class PickerOption<T> {
  const PickerOption({required this.value, required this.label, this.sublabel});

  final T value;
  final String label;
  final String? sublabel;
}

/// A card-style single-choice field that opens its options in a sheet.
///
/// Used for "start from" selectors (property, scenario), frequency, and
/// category pickers. Options are compared with `==`.
class OptionPickerField<T> extends StatelessWidget {
  const OptionPickerField({
    super.key,
    required this.label,
    required this.sheetTitle,
    this.sheetSubtitle,
    required this.options,
    required this.value,
    required this.onChanged,
    this.icon = Icons.copy_outlined,
  });

  /// Small caption shown above the selected value, e.g. 'Based on'.
  final String label;

  /// Title shown at the top of the options sheet, e.g. 'Start from'.
  final String sheetTitle;
  final String? sheetSubtitle;
  final List<PickerOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;
  final IconData icon;

  String get _selectedLabel {
    for (final option in options) {
      if (option.value == value) return option.label;
    }
    return options.isEmpty ? '' : options.first.label;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _showSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showSheet(BuildContext context) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      _showCupertinoSheet(context);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      enableDrag: true,
      builder: (sheetContext) => DraggableScrollableSheet(
        // The whole sheet content (header, options, empty filler) shares
        // the sheet's scroll controller, so a drag starting anywhere on
        // the sheet drives it (and dismisses it past the minimum size)
        // like a native sheet, instead of only working over the options.
        initialChildSize: 0.6,
        minChildSize: 0.25,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0.6, 0.95],
        builder: (context, scrollController) => _DismissOnMinExtent(
          sheetContext: sheetContext,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              child: _OptionSheet<T>(
                title: sheetTitle,
                subtitle: sheetSubtitle,
                options: options,
                value: value,
                onChanged: onChanged,
                scrollController: scrollController,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// iOS-style sheet: the whole sheet content shares the
  /// [DraggableScrollableSheet]'s controller, so dragging down from
  /// anywhere drives the sheet, and dragging past the minimum size
  /// dismisses it like a native sheet.
  void _showCupertinoSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.2,
        maxChildSize: 1.0,
        snap: true,
        snapSizes: const [0.62, 1.0],
        expand: false,
        builder: (context, scrollController) => _DismissOnMinExtent(
          sheetContext: sheetContext,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: _OptionSheet<T>(
              title: sheetTitle,
              subtitle: sheetSubtitle,
              options: options,
              value: value,
              onChanged: onChanged,
              scrollController: scrollController,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pops the enclosing sheet when its [DraggableScrollableSheet] is dragged
/// down to (or past) its minimum size, mirroring native sheet dismissal.
class _DismissOnMinExtent extends StatelessWidget {
  const _DismissOnMinExtent({required this.sheetContext, required this.child});

  final BuildContext sheetContext;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var dismissScheduled = false;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        if (!dismissScheduled &&
            notification.extent <= notification.minExtent + 0.02) {
          dismissScheduled = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final navigator = Navigator.of(sheetContext);
            if (navigator.canPop()) navigator.pop();
          });
        }
        return false;
      },
      child: child,
    );
  }
}

class _OptionSheet<T> extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    this.subtitle,
    required this.options,
    required this.value,
    required this.onChanged,
    this.scrollController,
  });

  final String title;
  final String? subtitle;
  final List<PickerOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  /// From the enclosing [DraggableScrollableSheet]. The whole sheet content
  /// (header, option list, and empty filler) lives in one scrollable driven
  /// by this controller, so a drag starting anywhere on the sheet drives it
  /// instead of fighting it.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platform = Theme.of(context).platform;
    final isCupertino =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Header block. Kept inside the scrollable (rather than pinned above
        // it) so drags starting on the grabber, title, or subtitle drive
        // the sheet exactly like a native iOS page sheet.
        SliverToBoxAdapter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCupertino) ...[
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 36,
                    height: 5,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            (isCupertino
                                    ? theme.textTheme.headlineSmall
                                    : theme.textTheme.titleLarge)
                                ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (isCupertino)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          sliver: SliverList.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final selected = option.value == value;
              return _OptionTile(
                label: option.label,
                sublabel: option.sublabel,
                selected: selected,
                onTap: () {
                  onChanged(option.value);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        // Filler so the empty area below a short option list is part of the
        // same drag surface instead of a dead zone.
        const SliverFillRemaining(
          hasScrollBody: false,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    this.sublabel,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? sublabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (sublabel != null)
                      Text(
                        sublabel!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check, color: theme.colorScheme.primary, size: 21),
            ],
          ),
        ),
      ),
    );
  }
}
