import 'package:facture/features/settings/application/display_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persistence of the language/theme overrides: defaults, round-trips, and
/// graceful handling of unknown stored values.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('defaults to the system theme with no locale override', () async {
    final settings = await DisplaySettingsService.load();
    expect(settings.locale, isNull);
    expect(settings.themeMode, ThemeMode.system);
  });

  test(
    'locale round-trips, and clearing restores the system default',
    () async {
      await DisplaySettingsService.saveLocale(const Locale('en'));
      expect((await DisplaySettingsService.load()).locale, const Locale('en'));

      await DisplaySettingsService.saveLocale(null);
      final settings = await DisplaySettingsService.load();
      expect(settings.locale, isNull);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(DisplaySettingsService.localeKey), isFalse);
    },
  );

  test('theme mode round-trips', () async {
    await DisplaySettingsService.saveThemeMode(ThemeMode.dark);
    expect((await DisplaySettingsService.load()).themeMode, ThemeMode.dark);

    await DisplaySettingsService.saveThemeMode(ThemeMode.light);
    expect((await DisplaySettingsService.load()).themeMode, ThemeMode.light);
  });

  test('unknown stored values fall back to the system defaults', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      DisplaySettingsService.localeKey: 'es',
      DisplaySettingsService.themeKey: 'neon',
    });
    final settings = await DisplaySettingsService.load();
    expect(settings.locale, isNull);
    expect(settings.themeMode, ThemeMode.system);
  });
}
