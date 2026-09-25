import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_app.dart';

void main() {
  Future<void> pumpInvoices(WidgetTester tester, {Locale? locale}) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: TestApp(
          locale: locale,
          child: const InvoicesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('InvoicesScreen', () {
    testWidgets('shows app bar, empty state action and add button',
        (tester) async {
      await pumpInvoices(tester);

      expect(find.text('Invoices'), findsOneWidget);
      expect(find.text('New invoice'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('empty-state action opens the invoice form',
        (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.text('New invoice'));
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('FAB opens the invoice form', (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('French strings are used in French locale', (tester) async {
      await pumpInvoices(tester, locale: const Locale('fr'));

      expect(find.text('Factures'), findsOneWidget);
      expect(find.text('Nouvelle facture'), findsOneWidget);
    });
  });
}
