import 'package:facture/app/app.dart';
import 'package:facture/features/clients/presentation/clients_screen.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:facture/features/settings/presentation/how_it_works_screen.dart';
import 'package:facture/features/settings/presentation/settings_screen.dart';
import 'package:facture/features/settings/presentation/tax_explainer_screen.dart';
import 'package:facture/features/tools/presentation/tax_calculator_screen.dart';
import 'package:facture/features/tools/presentation/tools_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Taps a bottom-bar tab by label, scoped to the NavigationBar so page
/// content with the same text (e.g. the Clients summary stat) never matches.
Future<void> tapTab(WidgetTester tester, String label) => tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text(label),
      ),
    );

void main() {
  setUpAll(() {
    // The client directory reads from disk on first load; without this the
    // Future never completes in tests and the loading spinner spins forever.
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpShell(WidgetTester tester) {
    // Tall viewport: the settings list is lazily built, and the business
    // section makes it taller than the default 600px surface.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    return tester.pumpWidget(const FactureApp());
  }

  Future<void> goToSettings(WidgetTester tester) async {
    await pumpShell(tester);
    await tester.pumpAndSettle();
    await tapTab(tester, 'Settings');
    await tester.pumpAndSettle();
  }

  group('HomeShell tabs', () {
    testWidgets('switching tabs shows each screen', (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      expect(find.byType(InvoicesScreen), findsOneWidget);

      await tapTab(tester, 'Clients');
      await tester.pumpAndSettle();
      expect(find.byType(ClientsScreen), findsOneWidget);

      await tapTab(tester, 'Tools');
      await tester.pumpAndSettle();
      expect(find.byType(ToolsScreen), findsOneWidget);

      await tapTab(tester, 'Settings');
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      await tapTab(tester, 'Invoices');
      await tester.pumpAndSettle();
      expect(find.byType(InvoicesScreen), findsOneWidget);
    });

    testWidgets('big add button opens the invoice form', (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      // Fresh install: free tier still has room, so the form opens directly.
      await tester.tap(find.byKey(const ValueKey('addInvoiceButton')));
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('clients page has the big add button, no FAB',
        (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      await tapTab(tester, 'Clients');
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('addClientButton')), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });

  group('ToolsScreen', () {
    testWidgets('lists the tax calculator and email template', (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      await tapTab(tester, 'Tools');
      await tester.pumpAndSettle();

      expect(find.text('TPS/TVQ calculator'), findsOneWidget);
      expect(
        find.text('Add taxes or extract them from a total.'),
        findsOneWidget,
      );
      expect(find.text('Email template'), findsOneWidget);
    });

    testWidgets('calculator tile opens the tax calculator', (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      await tapTab(tester, 'Tools');
      await tester.pumpAndSettle();
      await tester.tap(find.text('TPS/TVQ calculator'));
      await tester.pumpAndSettle();

      expect(find.byType(TaxCalculatorScreen), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    testWidgets('shows business, learn and about sections', (tester) async {
      await goToSettings(tester);

      expect(find.text('Business'), findsOneWidget);
      expect(find.text('Business profile'), findsOneWidget);
      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('How Facture works'), findsOneWidget);
      expect(find.text('Understanding TPS/TVQ'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Send feedback'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Rate Facture'), 200);
      expect(find.text('Rate Facture'), findsOneWidget);
      expect(find.text('Version 0.1.0'), findsOneWidget);
    });

    testWidgets('tools moved out of settings', (tester) async {
      await goToSettings(tester);

      expect(find.text('TPS/TVQ calculator'), findsNothing);
      expect(find.text('Email template'), findsNothing);
    });

    testWidgets('guide tile opens the how-it-works screen', (tester) async {
      await goToSettings(tester);

      await tester.tap(find.text('How Facture works'));
      await tester.pumpAndSettle();

      expect(find.byType(HowItWorksScreen), findsOneWidget);
      expect(find.text('Add your client'), findsOneWidget);
    });

    testWidgets('tax tile opens the TPS/TVQ explainer', (tester) async {
      await goToSettings(tester);

      await tester.tap(find.text('Understanding TPS/TVQ'));
      await tester.pumpAndSettle();

      expect(find.byType(TaxExplainerScreen), findsOneWidget);
      expect(find.textContaining('TVQ (9.975%)'), findsOneWidget);
    });
  });

  group('InvoicesScreen', () {
    testWidgets('shows summary stats with zero values', (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      expect(find.text('Unpaid'), findsOneWidget);
      expect(find.text('Paid this month'), findsOneWidget);
      expect(find.text('Clients'), findsWidgets);
      expect(find.text('\$0'), findsNWidgets(2));
    });
  });
}
