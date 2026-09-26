import 'dart:convert';

import 'package:facture/features/business/data/business_profile_repository.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/logo/presentation/logo_creator_screen.dart';
import 'package:facture/features/tools/presentation/tools_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_helpers.dart';

void main() {
  Future<void> pumpTools(
    WidgetTester tester, {
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ToolsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Create logo tool opens the creator', (tester) async {
    await pumpTools(tester);

    expect(find.text('Create logo'), findsOneWidget);

    // The creator opens empty (no saved name), so there is no preview to
    // wait for: the route itself is the completion signal.
    await doRealAsync(
      tester,
      () => tester.tap(find.text('Create logo')),
      () => find.byType(LogoCreatorScreen).evaluate().isNotEmpty,
      'the creator to open',
    );
  });

  testWidgets('creator is prefilled with the saved business name', (
    tester,
  ) async {
    await pumpTools(
      tester,
      prefs: {
        BusinessProfileRepository.storageKey: jsonEncode(
          const BusinessProfile(name: 'Atelier Nord').toJson(),
        ),
      },
    );

    await doRealAsync(
      tester,
      () => tester.tap(find.text('Create logo')),
      () => find.byType(Image).evaluate().isNotEmpty,
      'the prefilled creator preview',
    );

    final nameField = tester.widget<TextField>(find.byType(TextField).first);
    expect(nameField.controller?.text, 'Atelier Nord');
  });
}
