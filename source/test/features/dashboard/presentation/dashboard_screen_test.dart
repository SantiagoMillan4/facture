import 'package:facture/features/clients/application/clients_providers.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/dashboard/presentation/dashboard_screen.dart';
import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_app.dart';
import '../../../test_helpers.dart';

Invoice _invoice({
  required String id,
  required String number,
  required String clientId,
  required DateTime issueDate,
  required DateTime dueDate,
  InvoiceStatus status = InvoiceStatus.draft,
}) =>
    Invoice(
      id: id,
      number: number,
      clientId: clientId,
      issueDate: issueDate,
      dueDate: dueDate,
      status: status,
      lines: const [
        InvoiceLineItem(
            id: 'l1', description: 'Design', quantity: 1, unitPrice: 100),
      ],
    );

void main() {
  setUpPrintingMock();

  late ProviderContainer container;

  Future<void> pumpDashboard(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(invoicesProvider.future);
    await container.read(clientsProvider.future);
    await container.read(clientsProvider.notifier).saveClient(
          const Client(id: 'c1', name: 'Alice Tremblay'),
        );
    await container.read(clientsProvider.notifier).saveClient(
          const Client(id: 'c2', name: 'Bob Bouchard'),
        );
    await container.read(invoicesProvider.notifier).saveInvoice(
          _invoice(
            id: 'i1',
            number: '2026-0001',
            clientId: 'c1',
            issueDate: DateTime(2026, 9, 20),
            dueDate: DateTime(2026, 10, 20),
          ),
        );
    await container.read(invoicesProvider.notifier).saveInvoice(
          _invoice(
            id: 'i2',
            number: '2026-0002',
            clientId: 'c2',
            issueDate: DateTime(2026, 9, 10),
            dueDate: DateTime(2026, 9, 15),
            status: InvoiceStatus.paid,
          ),
        );
    await container.read(invoicesProvider.notifier).saveInvoice(
          _invoice(
            id: 'i3',
            number: '2026-0003',
            clientId: 'c1',
            issueDate: DateTime(2026, 8, 1),
            dueDate: DateTime(2026, 8, 15),
            status: InvoiceStatus.sent,
          ),
        );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: DashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tapping an invoice opens its preview', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(find.text('2026-0001'));
    // Manual pumps: the preview holds a PdfPreview whose spinner never
    // settles without a native rasterizer.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Send invoice'), findsOneWidget);
  });

  testWidgets('search filters by invoice number', (tester) async {
    await pumpDashboard(tester);

    await tester.enterText(find.byType(TextField), '0002');
    await tester.pumpAndSettle();

    expect(find.text('2026-0002'), findsOneWidget);
    expect(find.text('2026-0001'), findsNothing);
    expect(find.text('2026-0003'), findsNothing);
  });

  testWidgets('search filters by client name', (tester) async {
    await pumpDashboard(tester);

    await tester.enterText(find.byType(TextField), 'bob');
    await tester.pumpAndSettle();

    expect(find.text('2026-0002'), findsOneWidget);
    expect(find.text('2026-0001'), findsNothing);
    expect(find.text('2026-0003'), findsNothing);
  });

  testWidgets('status filter shows only matching invoices', (tester) async {
    await pumpDashboard(tester);

    await tester.tap(find.widgetWithText(FilterChip, 'Paid'));
    await tester.pumpAndSettle();

    expect(find.text('2026-0002'), findsOneWidget);
    expect(find.text('2026-0001'), findsNothing);
    expect(find.text('2026-0003'), findsNothing);

    // i3 is sent with a past due date, so it reads as overdue.
    await tester.tap(find.widgetWithText(FilterChip, 'Overdue'));
    await tester.pumpAndSettle();

    expect(find.text('2026-0003'), findsOneWidget);
    expect(find.text('2026-0002'), findsNothing);
  });

  testWidgets('shows the summary stats', (tester) async {
    await pumpDashboard(tester);

    // i1 (100 + taxes) and i3 are unpaid; i2 is paid.
    expect(find.text('Unpaid'), findsOneWidget);
    expect(find.text('Paid this month'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // two clients
  });
}
