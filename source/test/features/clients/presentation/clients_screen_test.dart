import 'package:facture/features/clients/presentation/clients_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpClients(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ClientsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> addClient(WidgetTester tester, String name) async {
    await tester.tap(find.text('Add client'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, name);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  }

  group('ClientsScreen', () {
    testWidgets('shows the empty state when no clients exist', (
      tester,
    ) async {
      await pumpClients(tester);

      expect(find.text('No clients yet'), findsOneWidget);
      expect(find.text('Add client'), findsOneWidget);
    });

    testWidgets('adds a client through the form', (tester) async {
      await pumpClients(tester);

      await addClient(tester, 'Acme Inc');

      expect(find.text('Acme Inc'), findsOneWidget);
      expect(find.text('No clients yet'), findsNothing);
    });

    testWidgets('requires a name', (tester) async {
      await pumpClients(tester);

      await tester.tap(find.text('Add client'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Still on the form, with the validation message.
      expect(find.text('New client'), findsOneWidget);
      expect(find.text("Please enter the client's name."), findsOneWidget);
    });

    testWidgets('deletes a client with confirmation', (tester) async {
      await pumpClients(tester);
      await addClient(tester, 'Acme Inc');

      await tester.drag(find.text('Acme Inc'), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Delete client?'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Delete'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No clients yet'), findsOneWidget);
      expect(find.text('Acme Inc'), findsNothing);
    });

    testWidgets('edits a client by tapping its row', (tester) async {
      await pumpClients(tester);
      await addClient(tester, 'Acme Inc');

      await tester.tap(find.text('Acme Inc'));
      await tester.pumpAndSettle();
      expect(find.text('Edit client'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField).first,
        'Acme Incorporated',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Acme Incorporated'), findsOneWidget);
      expect(find.text('Acme Inc'), findsNothing);
    });

    testWidgets('search filters clients by name', (tester) async {
      await pumpClients(tester);
      await addClient(tester, 'Acme Inc');
      await addClient(tester, 'Beta Corp');

      await tester.enterText(find.byType(TextField), 'acme');
      await tester.pumpAndSettle();

      expect(find.text('Acme Inc'), findsOneWidget);
      expect(find.text('Beta Corp'), findsNothing);
    });

    testWidgets('search shows a no-results state', (tester) async {
      await pumpClients(tester);
      await addClient(tester, 'Acme Inc');

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('No matching clients'), findsOneWidget);
      expect(find.text('Acme Inc'), findsNothing);
    });

    testWidgets('sort sheet switches the list order', (tester) async {
      await pumpClients(tester);
      await addClient(tester, 'Alpha');
      await addClient(tester, 'Beta');

      List<String?> rowNames() => tester
          .widgetList<ListTile>(find.byType(ListTile))
          .map((tile) => (tile.title! as Text).data)
          .toList();

      // Default: name ascending.
      expect(rowNames(), ['Alpha', 'Beta']);

      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Name (Z–A)'));
      await tester.pumpAndSettle();

      expect(rowNames(), ['Beta', 'Alpha']);
    });
  });
}
