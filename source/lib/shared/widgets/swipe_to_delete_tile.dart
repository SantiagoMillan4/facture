import 'package:flutter/material.dart';

import '../../l10n/app_l10n.dart';

import '../theme/app_theme.dart';
import 'app_haptics.dart';
import 'confirm_action_dialog.dart';

/// Apple Clock/Mail-style swipe-left-to-reveal-Delete row.
///
/// Swiping reveals the Delete action. Tapping Delete either immediately
/// deletes the item or, when [confirmDelete] is true, shows the shared
/// platform-appropriate confirmation dialog.
class SwipeToDeleteTile extends StatefulWidget {
  const SwipeToDeleteTile({
    super.key,
    required this.child,
    required this.onDelete,
    this.borderRadius = AppRadii.card,
    this.confirmDelete = false,
    this.deleteTitle = 'Delete?',
    this.deleteMessage = 'Are you sure you want to delete this item?',
  });

  final Widget child;
  final VoidCallback onDelete;
  final double borderRadius;

  /// Whether tapping Delete should show a confirmation dialog first.
  final bool confirmDelete;

  /// Title used by the confirmation dialog.
  final String deleteTitle;

  /// Message used by the confirmation dialog.
  final String deleteMessage;

  @override
  State<SwipeToDeleteTile> createState() => _SwipeToDeleteTileState();
}

class _SwipeToDeleteTileState extends State<SwipeToDeleteTile>
    with SingleTickerProviderStateMixin {
  static const _revealWidth = 88.0;

  late final AnimationController _snapController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  double _dragExtent = 0;

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    final animation = Tween<double>(
      begin: _dragExtent,
      end: target,
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));

    void listener() => setState(() => _dragExtent = animation.value);

    animation.addListener(listener);

    _snapController
      ..reset()
      ..forward().whenCompleteOrCancel(
        () => animation.removeListener(listener),
      );
  }

  void _close() => _animateTo(0);

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent = (_dragExtent + details.delta.dx).clamp(-_revealWidth, 0.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldOpen = _dragExtent <= -_revealWidth / 2 || velocity < -300;

    _animateTo(shouldOpen ? -_revealWidth : 0);
  }

  Future<void> _handleDelete() async {
    _close();
    AppHaptics.tap();

    if (!widget.confirmDelete) {
      widget.onDelete();
      return;
    }

    final confirmed = await showConfirmActionDialog(
      context,
      title: widget.deleteTitle,
      message: widget.deleteMessage,
      confirmLabel: context.l10n.delete,
    );

    if (confirmed && mounted) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: theme.colorScheme.error,
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: _revealWidth,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _handleDelete,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.onError,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.delete,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onError,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            onTap: _dragExtent == 0 ? null : _close,
            child: Transform.translate(
              offset: Offset(_dragExtent, 0),
              child: AbsorbPointer(
                absorbing: _dragExtent != 0,
                // Opaque row background: the delete layer sits behind the
                // row, so a transparent child would let the red show
                // through at rest. A Material (not a ColoredBox) keeps
                // ListTile ink splashes working.
                child: Material(
                  color: theme.colorScheme.surfaceContainerLow,
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
