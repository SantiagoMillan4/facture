import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/invoices/presentation/invoices_screen.dart';
import '../l10n/app_localizations.dart';
import '../shared/theme/app_theme.dart';

/// Root widget: Riverpod scope, Material 3 theme (light/dark), and
/// EN/Québec-French localization with English fallback.
///
/// French-first: the device locale resolves to French whenever the device
/// prefers it; anything else falls back to English.
class FactureApp extends StatelessWidget {
  const FactureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Facture',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        localeListResolutionCallback: (locales, supported) {
          for (final locale in locales ?? const <Locale>[]) {
            if (locale.languageCode == 'fr') return const Locale('fr');
            if (locale.languageCode == 'en') return const Locale('en');
          }
          return const Locale('en');
        },
        home: const InvoicesScreen(),
      ),
    );
  }
}
