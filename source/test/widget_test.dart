import 'package:facture/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app launches on the dashboard with three tabs',
      (tester) async {
    await tester.pumpWidget(const FactureApp());
    await tester.pumpAndSettle();

    // Default test locale is English.
    expect(find.text('Dashboard'), findsWidgets); // app bar + tab label
    expect(find.text('Invoices'), findsOneWidget); // tab label
    expect(find.text('Settings'), findsOneWidget); // tab label
    expect(find.text('Recent invoices'), findsOneWidget);

    // Switch to the invoices tab.
    await tester.tap(find.text('Invoices'));
    await tester.pumpAndSettle();
    expect(find.text('No invoices yet'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });
}
