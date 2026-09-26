import 'package:facture/features/catalog/application/catalog_providers.dart';
import 'package:facture/features/catalog/domain/catalog_item.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_helpers.dart';

Finder fieldByLabel(String label) => find.ancestor(
      of: find.text(label),
      matching: find.byType(TextFormField),
    );

void main() {
  setUpPrintingMock();

  late ProviderContainer container;

  Future<void> pumpForm(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
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
              return const InvoiceFormScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('Invoice form catalog integration', () {
    testWidgets('add line adds a blank row when the catalog is empty',
        (tester) async {
      await pumpForm(tester);

      await tester.tap(find.text('Add line'));
      await tester.pumpAndSettle();

      // No sheet: the second blank row appears directly.
      expect(find.text('From catalog…'), findsNothing);
      expect(fieldByLabel('Description'), findsNWidgets(2));
    });

    testWidgets('add line offers the catalog when it has items', (tester) async {
      await pumpForm(tester);
      await container.read(catalogItemsProvider.notifier).saveItem(
            const CatalogItem(
              id: 'ci1',
              description: 'Logo design',
              unitPriceCents: 7500,
            ),
          );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add line'));
      await tester.pumpAndSettle();
      expect(find.text('From catalog…'), findsOneWidget);

      await tester.tap(find.text('From catalog…'));
      await tester.pumpAndSettle();
      expect(find.text('Logo design'), findsOneWidget);

      await tester.tap(find.text('Logo design'));
      await tester.pumpAndSettle();

      // A second row was added with the catalog values prefilled.
      expect(fieldByLabel('Description'), findsNWidgets(2));
      expect(find.text('Logo design'), findsOneWidget);
    });
  });
}
