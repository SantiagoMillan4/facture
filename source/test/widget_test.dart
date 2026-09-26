import 'package:facture/app/app.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app launches on Invoices with the new tab bar', (tester) async {
    // Providers read on-device storage; the mock keeps them resolving
    // instead of hanging on the real method channel.
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const FactureApp());
    await tester.pumpAndSettle();

    // Default test locale is English.
    expect(find.text('Invoices'), findsWidgets); // app bar + tab label
    expect(find.text('Clients'), findsWidgets); // tab label + summary stat
    expect(find.text('Tools'), findsOneWidget); // tab label
    expect(find.text('Settings'), findsOneWidget); // tab label
    expect(find.text('New invoice'), findsWidgets); // center btn + empty state
    expect(find.text('Search invoices'), findsOneWidget); // list search

    // The Tools tab lists the tax calculator and the email template.
    await tester.tap(find.byKey(const ValueKey('navTab2')));
    await tester.pumpAndSettle();
    expect(find.text('TPS/TVQ calculator'), findsOneWidget);
    expect(find.text('Email template'), findsOneWidget);

    // Back on Invoices, the center button opens the invoice form.
    await tester.tap(find.byKey(const ValueKey('navTab0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('newInvoiceButton')));
    await tester.pumpAndSettle();
    expect(find.byType(InvoiceFormScreen), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
