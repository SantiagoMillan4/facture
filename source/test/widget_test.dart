import 'package:facture/app/app.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/onboarding/application/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app launches on Invoices with the new tab bar', (tester) async {
    // Providers read on-device storage; the mock keeps them resolving
    // instead of hanging on the real method channel. The onboarding flag
    // simulates a returning user, straight into the tab shell.
    SharedPreferences.setMockInitialValues({OnboardingService.doneKey: true});
    await tester.pumpWidget(const FactureApp());
    await tester.pumpAndSettle();

    // Default test locale is English.
    expect(find.text('Invoices'), findsWidgets); // app bar + tab label
    expect(find.text('Clients'), findsWidgets); // tab label + summary stat
    expect(find.text('Tools'), findsOneWidget); // tab label
    expect(find.text('Settings'), findsOneWidget); // tab label
    expect(find.text('New invoice'), findsWidgets); // center btn + empty state
    expect(find.text('Search invoices'), findsOneWidget); // list search

    // The Tools tab lists the tax calculator.
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Tools'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('TPS/TVQ calculator'), findsOneWidget);

    // Back on Invoices, the big button opens the invoice form.
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Invoices'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('addInvoiceButton')));
    await tester.pumpAndSettle();
    expect(find.byType(InvoiceFormScreen), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
