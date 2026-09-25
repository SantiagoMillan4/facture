import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// Fades and slides a list item in on first appearance, with a per-index
/// delay so lists cascade gently. The total cascade is capped
/// ([AppMotion.staggerMaxDelay]) and reduced-motion renders the child
/// immediately with no animation.
class StaggeredEntrance extends StatefulWidget {
  const StaggeredEntrance({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<StaggeredEntrance> createState() => _StaggeredEntranceState();
}

class _StaggeredEntranceState extends State<StaggeredEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.staggerDuration,
  );
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    final delayMs = (widget.index * AppMotion.staggerStep.inMilliseconds).clamp(
      0,
      AppMotion.staggerMaxDelay.inMilliseconds,
    );
    _delay = Timer(Duration(milliseconds: delayMs), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppMotion.animationsEnabled(context)) return widget.child;
    final curved = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.entranceCurve,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved),
        child: widget.child,
      ),
    );
  }
}
