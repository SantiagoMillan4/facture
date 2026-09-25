import 'package:facture/features/business/application/business_profile_providers.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/business/presentation/business_profile_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return const BusinessProfileScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder fieldByLabel(String label) => find.ancestor(
    of: find.text(label),
    matching: find.byType(TextFormField),
  );

  testWidgets('saving stores the profile with small-supplier status', (
    tester,
  ) async {
    await pumpScreen(tester);

    await tester.enterText(fieldByLabel('Business name'), 'Atelier Nord');
    // Tax numbers hidden until registered is (re)selected; pick small
    // supplier and confirm the number fields disappear.
    await tester.tap(find.text('Small supplier'));
    await tester.pumpAndSettle();
    expect(fieldByLabel('TPS registration number'), findsNothing);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await container.read(businessProfileProvider.future);
    expect(
      saved,
      const BusinessProfile(
        name: 'Atelier Nord',
        taxStatus: TaxRegistrationStatus.smallSupplier,
      ),
    );
  });

  testWidgets('registered status shows tax number fields', (tester) async {
    await pumpScreen(tester);

    expect(
      fieldByLabel('TPS registration number'),
      findsOneWidget,
      reason: 'registered is the default status',
    );
    await tester.enterText(
      fieldByLabel('TPS registration number'),
      '123456789RT0001',
    );
    await tester.enterText(fieldByLabel('Business name'), 'Atelier Nord');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await container.read(businessProfileProvider.future);
    expect(saved?.tpsNumber, '123456789RT0001');
    expect(saved?.chargesTaxes, isTrue);
  });

  testWidgets('business name is required', (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Enter your business name'), findsOneWidget);
    final saved = await container.read(businessProfileProvider.future);
    expect(saved, isNull);
  });
}
