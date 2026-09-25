import 'package:facture/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('app launches on the dashboard with four tabs',
      (tester) async {
    // Providers read on-device storage; the mock keeps them resolving
    // instead of hanging on the real method channel.
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const FactureApp());
    await tester.pumpAndSettle();

    // Default test locale is English.
    expect(find.text('Dashboard'), findsWidgets); // app bar + tab label
    expect(find.text('Invoices'), findsOneWidget); // tab label
    expect(find.text('Clients'), findsWidgets); // tab label + dashboard stat
    expect(find.text('Settings'), findsOneWidget); // tab label
    expect(find.text('Recent invoices'), findsOneWidget);

    // Switch to the invoices tab.
    await tester.tap(find.text('Invoices'));
    await tester.pumpAndSettle();
    expect(find.text('No invoices yet'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
