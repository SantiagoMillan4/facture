import 'package:facture/features/settings/application/display_settings.dart';
import 'package:facture/features/settings/presentation/display_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_app.dart';

/// The Appearance section: picking a language or theme updates the provider
/// immediately and persists the choice.
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<ProviderContainer> pumpSection(WidgetTester tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: Scaffold(body: DisplaySettingsSection())),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows both pickers defaulting to the system', (tester) async {
    await pumpSection(tester);

    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    // Both tiles show the system default as their current value.
    expect(find.text('System default'), findsNWidgets(2));
  });

  testWidgets('choosing a language persists it and updates the provider', (
    tester,
  ) async {
    final container = await pumpSection(tester);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();

    expect(container.read(localeOverrideProvider), const Locale('fr'));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(DisplaySettingsService.localeKey), 'fr');
    // The tile now shows the choice.
    expect(find.text('Français'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('choosing a theme persists it and updates the provider', (
    tester,
  ) async {
    final container = await pumpSection(tester);

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    expect(container.read(themeModeProvider), ThemeMode.dark);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(DisplaySettingsService.themeKey), 'dark');
    // The tile now shows the choice.
    expect(find.text('Dark'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dismissing the sheet keeps the previous choice', (tester) async {
    final container = await pumpSection(tester);

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();
    // Dismiss without choosing (tap outside / back).
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(container.read(themeModeProvider), ThemeMode.system);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.containsKey(DisplaySettingsService.themeKey), isFalse);
    expect(tester.takeException(), isNull);
  });
}
