import 'package:flutter/services.dart';

/// Tasteful, minimal haptic feedback for key actions.
///
/// Used sparingly: successful saves, deletions, and creations. Never for
/// passive events like scrolling or tab switches.
class AppHaptics {
  AppHaptics._();

  /// Light tap for destructive or dismissive actions (delete, cancel).
  static Future<void> tap() => HapticFeedback.lightImpact();

  /// Confirmation for successful saves and creations.
  static Future<void> confirm() => HapticFeedback.mediumImpact();
}
