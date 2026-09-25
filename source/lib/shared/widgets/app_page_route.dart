import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// The app's standard page transition: a subtle fade combined with a short
/// horizontal slide. Quiet enough to feel native, distinct enough to feel
/// deliberate. Honors reduced-motion settings.
///
/// Use [pushAppPage]/[pushReplacementAppPage] instead of constructing
/// [MaterialPageRoute] directly at call sites.
class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({required WidgetBuilder builder, super.settings})
    : super(
        pageBuilder: (context, _, _) => builder(context),
        transitionDuration: AppMotion.pageTransition,
        reverseTransitionDuration: AppMotion.pageTransition,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (!AppMotion.animationsEnabled(context)) return child;
          final curved = CurvedAnimation(
            parent: animation,
            curve: AppMotion.entranceCurve,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      );
}

/// Pushes a page with the app's standard transition.
Future<T?> pushAppPage<T>(BuildContext context, WidgetBuilder builder) {
  return Navigator.of(context).push<T>(AppPageRoute(builder: builder));
}

/// Replaces the current page with the app's standard transition.
Future<T?> pushReplacementAppPage<T, R>(
  BuildContext context,
  WidgetBuilder builder,
) {
  return Navigator.of(
    context,
  ).pushReplacement<T, R>(AppPageRoute(builder: builder));
}
