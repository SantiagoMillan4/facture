import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

/// Convenient access to the app's localizations from any [BuildContext].
extension AppL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Whether the app is currently running in French (Québec).
  bool get isFrench => Localizations.localeOf(this).languageCode == 'fr';
}
