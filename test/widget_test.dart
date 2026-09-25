import 'package:facture/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app launches on the invoices screen', (tester) async {
    await tester.pumpWidget(const FactureApp());
    await tester.pumpAndSettle();

    // Default test locale is English.
    expect(find.text('Invoices'), findsOneWidget);
    expect(find.text('No invoices yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
