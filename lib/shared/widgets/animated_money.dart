import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// A number (typically money) that smoothly ticks from its old value to its
/// new value instead of jumping. Pass a [format] function such as
/// [formatCompactCurrency] or [formatFullCurrency].
///
/// Interrupted updates retarget from the currently displayed value, so rapid
/// changes never snap. Reduced-motion renders the value statically.
class AnimatedMoney extends StatefulWidget {
  const AnimatedMoney({
    super.key,
    required this.value,
    required this.format,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final double value;
  final String Function(double value) format;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<AnimatedMoney> createState() => _AnimatedMoneyState();
}

class _AnimatedMoneyState extends State<AnimatedMoney>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.numberTick,
  );

  var _from = 0.0;
  var _to = 0.0;
  var _displayed = 0.0;

  @override
  void initState() {
    super.initState();
    _from = _to = _displayed = widget.value;
    _controller.addListener(() {
      setState(() {
        _displayed = _from + (_to - _from) * _controller.value;
      });
    });
  }

  @override
  void didUpdateWidget(AnimatedMoney oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _from = _displayed;
      _to = widget.value;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!AppMotion.animationsEnabled(context)) {
      return Text(
        widget.format(widget.value),
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
        overflow: widget.overflow,
      );
    }
    return Text(
      widget.format(_displayed),
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
