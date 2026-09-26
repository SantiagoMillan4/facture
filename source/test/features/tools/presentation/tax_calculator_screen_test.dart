import 'package:facture/features/tools/presentation/tax_calculator_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCalculator(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TaxCalculatorScreen(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('TaxCalculatorScreen', () {
    testWidgets('adds taxes to a pre-tax amount', (tester) async {
      await pumpCalculator(tester);

      await tester.enterText(find.byType(TextField), '100');
      await tester.pump();

      // $100 pre-tax -> $5.00 TPS, $10.47 TVQ, $115.47 total.
      expect(find.text('\$5.00'), findsOneWidget);
      expect(find.text('\$10.47'), findsOneWidget);
      expect(find.text('\$115.47'), findsOneWidget);
    });

    testWidgets('extracts taxes from a tax-included total', (tester) async {
      await pumpCalculator(tester);

      await tester.tap(find.text('Taxes included'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '115.47');
      await tester.pump();

      // $115.47 tax-included -> $100.00 pre-tax, $5.00 TPS, $10.47 TVQ.
      expect(find.text('\$100.00'), findsOneWidget);
      expect(find.text('\$5.00'), findsOneWidget);
      expect(find.text('\$10.47'), findsOneWidget);
    });

    testWidgets('formats amounts in French', (tester) async {
      await pumpCalculator(tester, locale: const Locale('fr'));

      await tester.enterText(find.byType(TextField), '100');
      await tester.pump();

      // Québec French: `115,47 $`.
      expect(find.textContaining('115,47'), findsOneWidget);
    });

    testWidgets('empty amount shows zeros', (tester) async {
      await pumpCalculator(tester);

      expect(find.text('\$0.00'), findsWidgets);
    });
  });
}
