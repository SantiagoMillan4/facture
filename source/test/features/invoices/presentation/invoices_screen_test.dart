import 'package:facture/features/invoices/presentation/create_invoice_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:facture/features/settings/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_app.dart';

void main() {
  Future<void> pumpInvoices(WidgetTester tester, {Locale? locale}) {
    return tester.pumpWidget(TestApp(
      locale: locale,
      child: const InvoicesScreen(),
    ));
  }

  group('InvoicesScreen', () {
    testWidgets('shows app bar, empty state action and add button',
        (tester) async {
      await pumpInvoices(tester);

      expect(find.text('Invoices'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.text('New invoice'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('empty-state action opens the create-invoice screen',
        (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.text('New invoice'));
      await tester.pumpAndSettle();

      expect(find.byType(CreateInvoiceScreen), findsOneWidget);
    });

    testWidgets('FAB opens the create-invoice screen', (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(CreateInvoiceScreen), findsOneWidget);
    });

    testWidgets('settings action opens the settings screen', (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('French strings are used in French locale', (tester) async {
      await pumpInvoices(tester, locale: const Locale('fr'));

      expect(find.text('Factures'), findsOneWidget);
      expect(find.text('Nouvelle facture'), findsOneWidget);
    });
  });
}
