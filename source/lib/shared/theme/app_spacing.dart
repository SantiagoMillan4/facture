import 'package:flutter/widgets.dart';

/// Centralized spacing scale for padding, margins, and gaps between
/// elements. Prefer these over new magic numbers so spacing stays
/// consistent app-wide; genuinely one-off values may still be left as-is.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Standard horizontal inset for top-level screen bodies.
  static const double screenHorizontal = xl;

  /// Standard padding for scrollable screen bodies (lists of cards, etc.).
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(xl, xl, xl, xxxl);

  /// Standard inner padding for dashboard/analysis summary cards.
  static const double cardPadding = 18;
}
