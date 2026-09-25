import 'package:flutter/material.dart';
import 'package:facture/l10n/app_localizations.dart';

/// Test wrapper mirroring [FactureApp]'s localization setup so
/// widgets calling `context.l10n` resolve in widget tests.
class TestApp extends StatelessWidget {
  const TestApp({
    super.key,
    required this.child,
    this.locale,
    this.themeMode = ThemeMode.light,
  });

  final Widget child;

  /// Forces a locale, e.g. `const Locale('fr')` for French-string tests.
  final Locale? locale;

  /// Forces a brightness, e.g. `ThemeMode.dark` for dark-mode tests.
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }
}
