import 'dart:io';

import 'package:facture/features/business/application/business_profile_providers.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/business/presentation/business_profile_screen.dart';
import 'package:facture/features/logo/presentation/logo_creator_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_helpers.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Tall viewport: the form is a lazily-built ListView, and the logo
    // section makes it taller than the default 600px surface, which would
    // leave the tax fields unbuilt.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
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

  Finder fieldByLabel(String label) =>
      find.ancestor(of: find.text(label), matching: find.byType(TextFormField));

  /// Mocks path_provider with a temp documents dir for generated logo files.
  Future<void> mockDocumentsDir() async {
    final tempDir = Directory.systemTemp.createTempSync('logo_profile_test');
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            null,
          );
      tempDir.deleteSync(recursive: true);
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => tempDir.path,
        );
  }

  /// Opens the creator from the profile screen and saves the generated
  /// logo, returning to the profile form.
  Future<void> createLogoFromProfile(WidgetTester tester) async {
    // The creator is prefilled from the draft name; wait for its preview
    // in the same real-async block as the open tap.
    await doRealAsync(
      tester,
      () => tester.tap(find.text('Create a logo')),
      () => find.byType(Image).evaluate().isNotEmpty,
      'the creator preview',
    );
    // Saving the logo persists a small-supplier profile behind the form.
    await doRealAsync(
      tester,
      () => tester.tap(find.widgetWithText(OutlinedButton, 'Use this logo')),
      () => find.byType(LogoCreatorScreen).evaluate().isEmpty,
      'the creator to close',
    );
  }

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

  testWidgets('shows the logo tile and keeps the logo on save', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Logo'), findsOneWidget);

    // Saving without touching the logo keeps a null logoPath.
    await tester.enterText(fieldByLabel('Business name'), 'Atelier Nord');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await container.read(businessProfileProvider.future);
    expect(saved?.logoPath, isNull);
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

  testWidgets(
    'creating a logo before saving the form cannot silently enable taxes',
    (tester) async {
      await mockDocumentsDir();
      await pumpScreen(tester);

      // Type a name but don't save: a fresh form defaults to registered,
      // which the logo creator must not let through silently.
      await tester.enterText(fieldByLabel('Business name'), 'Atelier Nord');
      await createLogoFromProfile(tester);

      // The draft name survives, and the form's tax status follows the
      // profile the creator established: the TPS number fields are gone.
      final nameField = tester.widget<TextFormField>(
        fieldByLabel('Business name'),
      );
      expect(nameField.controller?.text, 'Atelier Nord');
      expect(fieldByLabel('TPS registration number'), findsNothing);

      // Saving the form keeps taxes off and attaches the logo.
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final saved = await container.read(businessProfileProvider.future);
      expect(saved?.taxStatus, TaxRegistrationStatus.smallSupplier);
      expect(saved?.logoPath, isNotNull);
    },
  );

  testWidgets('an explicit tax choice survives creating a logo', (
    tester,
  ) async {
    await mockDocumentsDir();
    await pumpScreen(tester);

    await tester.enterText(fieldByLabel('Business name'), 'Atelier Nord');
    // Explicitly choose registered (via small supplier and back, so the
    // choice is a real change from the default).
    await tester.tap(find.text('Small supplier'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registered'));
    await tester.pumpAndSettle();

    await createLogoFromProfile(tester);

    // The explicit registered choice is untouched: the TPS field is shown.
    expect(fieldByLabel('TPS registration number'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final saved = await container.read(businessProfileProvider.future);
    expect(saved?.taxStatus, TaxRegistrationStatus.registered);
    expect(saved?.logoPath, isNotNull);
  });
}
