import 'package:facture/features/catalog/application/catalog_providers.dart';
import 'package:facture/features/catalog/domain/catalog_item.dart';
import 'package:facture/features/catalog/presentation/catalog_item_edit_screen.dart';
import 'package:facture/features/catalog/presentation/catalog_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CatalogScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('empty state and add button', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Services & items'), findsOneWidget);
    expect(find.byKey(const ValueKey('addCatalogItemButton')), findsOneWidget);
    expect(find.text('No saved items yet'), findsOneWidget);
  });

  testWidgets('add button opens the editor, saving adds the item',
      (tester) async {
    await pumpScreen(tester);

    await tester.tap(find.byKey(const ValueKey('addCatalogItemButton')));
    await tester.pumpAndSettle();
    expect(find.byType(CatalogItemEditScreen), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Logo design');
    await tester.enterText(find.byType(TextFormField).last, '75');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Logo design'), findsOneWidget);
    expect(find.text('No saved items yet'), findsNothing);
  });

  testWidgets('lists a saved item with its price', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(catalogItemsProvider.notifier).saveItem(
          const CatalogItem(
            id: 'ci1',
            description: 'Design',
            unitPriceCents: 5000,
          ),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CatalogScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Design'), findsOneWidget);
    // Price shown with cents in English locale.
    expect(find.textContaining('50.00'), findsOneWidget);
  });
}
