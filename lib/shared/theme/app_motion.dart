import 'package:flutter/widgets.dart';

/// Central motion language for the app: one set of durations and curves so
/// animations feel consistent everywhere. All motion widgets consult
/// [animationsEnabled] and render their final state immediately when the
/// platform requests reduced motion.
class AppMotion {
  AppMotion._();

  /// Standard page push/pop transition length.
  static const Duration pageTransition = Duration(milliseconds: 260);

  /// Delay between items in a staggered list entrance.
  static const Duration staggerStep = Duration(milliseconds: 55);

  /// Upper bound for the total stagger cascade so long lists don't keep
  /// animating while the user is already scrolling.
  static const Duration staggerMaxDelay = Duration(milliseconds: 330);

  /// Length of a single staggered item's entrance.
  static const Duration staggerDuration = Duration(milliseconds: 280);

  /// How long an animated number takes to tick from the old to the new value.
  static const Duration numberTick = Duration(milliseconds: 650);

  /// Minimum time the animated splash stays visible (brand moment), even if
  /// startup work finishes sooner.
  static const Duration splashMin = Duration(milliseconds: 1400);

  /// Entrance curve shared by pages, lists, and the splash.
  static const Curve entranceCurve = Curves.easeOutCubic;

  /// False when the OS (or the test harness) requests reduced motion.
  static bool animationsEnabled(BuildContext context) =>
      !MediaQuery.of(context).disableAnimations;
}
