import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The user's theme choice. [ThemeMode.system] (the default) follows the
/// device appearance.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

/// The user's language override. Null (the default) follows the device
/// language.
final localeOverrideProvider =
    NotifierProvider<LocaleOverrideNotifier, Locale?>(
      LocaleOverrideNotifier.new,
    );

class LocaleOverrideNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void set(Locale? locale) => state = locale;
}

/// Persists the language/theme overrides chosen in Settings. A null locale
/// (system default) is stored as a missing key.
class DisplaySettingsService {
  static const localeKey = 'facture.locale_override.v1';
  static const themeKey = 'facture.theme_override.v1';

  static Future<({Locale? locale, ThemeMode themeMode})> load() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(localeKey);
    final locale = (localeCode == 'en' || localeCode == 'fr')
        ? Locale(localeCode!)
        : null;
    return (
      locale: locale,
      themeMode: _themeModeFrom(prefs.getString(themeKey)),
    );
  }

  static Future<void> saveLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    final code = locale?.languageCode;
    if (code == null) {
      await prefs.remove(localeKey);
    } else {
      await prefs.setString(localeKey, code);
    }
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(themeKey, mode.name);
  }

  static ThemeMode _themeModeFrom(String? name) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => ThemeMode.system,
    );
  }
}
