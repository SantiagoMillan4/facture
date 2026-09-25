import 'package:facture/app/app.dart';
import 'package:facture/features/clients/presentation/clients_screen.dart';
import 'package:facture/features/dashboard/presentation/dashboard_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:facture/features/settings/presentation/how_it_works_screen.dart';
import 'package:facture/features/settings/presentation/settings_screen.dart';
import 'package:facture/features/settings/presentation/tax_explainer_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() {
    // The client directory reads from disk on first load; without this the
    // Future never completes in tests and the loading spinner spins forever.
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> pumpShell(WidgetTester tester) {
    return tester.pumpWidget(const FactureApp());
  }

  Future<void> goToSettings(WidgetTester tester) async {
    await pumpShell(tester);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
  }

  group('HomeShell tabs', () {
    testWidgets('switching tabs shows each screen', (tester) async {
      await pumpShell(tester);
      await tester.pumpAndSettle();

      expect(find.byType(DashboardScreen), findsOneWidget);

      await tester.tap(find.text('Invoices'));
      await tester.pumpAndSettle();
      expect(find.byType(InvoicesScreen), findsOneWidget);

      await tester.tap(find.text('Clients'));
      await tester.pumpAndSettle();
      expect(find.byType(ClientsScreen), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);

      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });

  group('SettingsScreen', () {
    testWidgets('shows learn, tools and about sections', (tester) async {
      await goToSettings(tester);

      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('How Facture works'), findsOneWidget);
      expect(find.text('Understanding TPS/TVQ'), findsOneWidget);
      expect(find.text('Tools'), findsOneWidget);
      expect(find.text('TPS/TVQ calculator'), findsOneWidget);
      expect(
        find.text('Add taxes or extract them from a total.'),
        findsOneWidget,
      );
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Send feedback'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Rate Facture'), 200);
      expect(find.text('Rate Facture'), findsOneWidget);
      expect(find.text('Version 0.1.0'), findsOneWidget);
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

  group('DashboardScreen', () {
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
