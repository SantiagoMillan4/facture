import 'package:facture/features/clients/application/clients_providers.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/invoices/presentation/invoice_list_tile.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
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
}) => Invoice(
  id: id,
  number: number,
  clientId: clientId,
  issueDate: issueDate,
  dueDate: dueDate,
  status: status,
  lines: const [
    InvoiceLineItem(
      id: 'l1',
      description: 'Design',
      quantity: 1,
      unitPrice: 100,
    ),
  ],
);

void main() {
  setUpPrintingMock();

  late ProviderContainer container;

  Future<void> pumpInvoices(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(invoicesProvider.future);
    await container.read(clientsProvider.future);
    await container
        .read(clientsProvider.notifier)
        .saveClient(const Client(id: 'c1', name: 'Alice Tremblay'));
    await container
        .read(clientsProvider.notifier)
        .saveClient(const Client(id: 'c2', name: 'Bob Bouchard'));
    await container
        .read(invoicesProvider.notifier)
        .saveInvoice(
          _invoice(
            id: 'i1',
            number: '2026-0001',
            clientId: 'c1',
            issueDate: DateTime(2026, 9, 20),
            dueDate: DateTime(2026, 10, 20),
          ),
        );
    await container
        .read(invoicesProvider.notifier)
        .saveInvoice(
          _invoice(
            id: 'i2',
            number: '2026-0002',
            clientId: 'c2',
            issueDate: DateTime(2026, 9, 10),
            dueDate: DateTime(2026, 9, 15),
            status: InvoiceStatus.paid,
          ),
        );
    await container
        .read(invoicesProvider.notifier)
        .saveInvoice(
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
        child: const TestApp(child: InvoicesScreen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('tapping an invoice opens its preview', (tester) async {
    await pumpInvoices(tester);

    await tester.tap(find.text('2026-0001'));
    // Manual pumps: the preview holds a PdfPreview whose spinner never
    // settles without a native rasterizer.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Share PDF'), findsOneWidget);
  });

  testWidgets('search filters by invoice number', (tester) async {
    await pumpInvoices(tester);

    await tester.enterText(find.byType(TextField), '0002');
    await tester.pumpAndSettle();

    expect(find.text('2026-0002'), findsOneWidget);
    expect(find.text('2026-0001'), findsNothing);
    expect(find.text('2026-0003'), findsNothing);
  });

  testWidgets('search filters by client name', (tester) async {
    await pumpInvoices(tester);

    await tester.enterText(find.byType(TextField), 'bob');
    await tester.pumpAndSettle();

    expect(find.text('2026-0002'), findsOneWidget);
    expect(find.text('2026-0001'), findsNothing);
    expect(find.text('2026-0003'), findsNothing);
  });

  testWidgets('status filter shows only matching invoices', (tester) async {
    await pumpInvoices(tester);

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
    await pumpInvoices(tester);

    // i1 (100 + taxes) and i3 are unpaid; i2 is paid.
    expect(find.text('Unpaid'), findsOneWidget);
    expect(find.text('Paid this month'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // two clients
  });

  group('needs attention', () {
    DateTime day(int offset) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day).add(Duration(days: offset));
    }

    Future<void> pumpAttention(WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(invoicesProvider.future);
      await container.read(clientsProvider.future);
      await container
          .read(clientsProvider.notifier)
          .saveClient(const Client(id: 'c1', name: 'Alice Tremblay'));
      Future<void> addInvoice(
        String id,
        String number,
        InvoiceStatus status,
        int issueOffset,
        int dueOffset,
      ) => container
          .read(invoicesProvider.notifier)
          .saveInvoice(
            _invoice(
              id: id,
              number: number,
              clientId: 'c1',
              issueDate: day(issueOffset),
              dueDate: day(dueOffset),
              status: status,
            ),
          );
      await addInvoice('overdue', '2026-0010', InvoiceStatus.sent, -10, -3);
      await addInvoice('due-soon', '2026-0011', InvoiceStatus.sent, -5, 2);
      await addInvoice('due-later', '2026-0012', InvoiceStatus.sent, -5, 30);
      await addInvoice('draft', '2026-0013', InvoiceStatus.draft, -5, 10);
      await addInvoice('paid', '2026-0014', InvoiceStatus.paid, -20, -10);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestApp(child: InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('lists overdue and due-soon invoices, most urgent first', (
      tester,
    ) async {
      await pumpAttention(tester);

      expect(find.text('Needs attention'), findsOneWidget);
      expect(find.text('Alice Tremblay • 3 days overdue'), findsOneWidget);
      expect(find.text('Alice Tremblay • Due in 2 days'), findsOneWidget);
      // Draft, paid and far-future invoices need no chasing.
      expect(find.text('Due in 30 days'), findsNothing);

      final overdueDy = tester
          .getTopLeft(find.text('Alice Tremblay • 3 days overdue'))
          .dy;
      final dueSoonDy = tester
          .getTopLeft(find.text('Alice Tremblay • Due in 2 days'))
          .dy;
      expect(overdueDy, lessThan(dueSoonDy));
    });

    testWidgets('tapping an attention row opens the preview', (tester) async {
      await pumpAttention(tester);

      await tester.tap(find.text('Alice Tremblay • 3 days overdue'));
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      expect(find.text('Share PDF'), findsOneWidget);
    });

    testWidgets('hidden when nothing needs chasing', (tester) async {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(invoicesProvider.future);
      await container.read(clientsProvider.future);
      await container
          .read(invoicesProvider.notifier)
          .saveInvoice(
            _invoice(
              id: 'paid',
              number: '2026-0014',
              clientId: 'c1',
              issueDate: day(-20),
              dueDate: day(-10),
              status: InvoiceStatus.paid,
            ),
          );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestApp(child: InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Needs attention'), findsNothing);
    });
  });

  group('empty state', () {
    Future<void> pumpEmpty(WidgetTester tester, {Locale? locale}) async {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(invoicesProvider.future);
      await container.read(clientsProvider.future);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(locale: locale, child: const InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('empty-state action opens the invoice form', (tester) async {
      await pumpEmpty(tester);

      expect(find.text('No invoices yet'), findsOneWidget);

      // Fresh install: free tier still has room, so the form opens directly.
      await tester.tap(find.text('New invoice'));
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('French strings are used in French locale', (tester) async {
      await pumpEmpty(tester, locale: const Locale('fr'));

      expect(find.text('Factures'), findsOneWidget);
      expect(find.text('Aucune facture'), findsOneWidget);
      expect(find.text('Nouvelle facture'), findsOneWidget);
      expect(find.text('Rechercher des factures'), findsOneWidget);
    });
  });

  group('status chip', () {
    Future<ProviderContainer> seedChipInvoice(
      WidgetTester tester,
      Invoice invoice,
    ) async {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(invoicesProvider.future);
      await container.read(clientsProvider.future);
      await container.read(invoicesProvider.notifier).saveInvoice(invoice);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const TestApp(child: InvoicesScreen()),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    Invoice draftInvoice() => Invoice(
      id: 'i1',
      number: '2026-0001',
      clientId: 'c1',
      issueDate: DateTime(2026, 9, 1),
      dueDate: DateTime(2026, 10, 1),
      status: InvoiceStatus.draft,
    );

    /// The tile's status chip — scoped to the list tile so the status
    /// filter chips at the top of the screen don't match.
    Finder tileChip(String label) => find.descendant(
      of: find.byType(InvoiceListTile),
      matching: find.text(label),
    );

    testWidgets('tapping the status chip offers the draft transitions', (
      tester,
    ) async {
      await seedChipInvoice(tester, draftInvoice());

      await tester.tap(tileChip('Draft'));
      await tester.pumpAndSettle();

      expect(find.text('Change status'), findsOneWidget);
      expect(find.text('Mark as sent'), findsOneWidget);
      expect(find.text('Mark as paid'), findsOneWidget);
      expect(find.text('Back to draft'), findsNothing);
    });

    testWidgets('marking as sent updates the chip and stamps the date', (
      tester,
    ) async {
      final seeded = await seedChipInvoice(tester, draftInvoice());

      await tester.tap(tileChip('Draft'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as sent'));
      await tester.pumpAndSettle();

      expect(tileChip('Sent'), findsOneWidget);
      expect(seeded.read(invoicesProvider).value!.single.sentDate, isNotNull);
    });

    testWidgets('paid invoice tile shows the paid date', (tester) async {
      await seedChipInvoice(
        tester,
        draftInvoice().copyWith(
          status: InvoiceStatus.paid,
          paidDate: DateTime(2026, 9, 20),
        ),
      );

      // "Paid this month" stat, the Paid filter chip, the tile chip, and the
      // "Paid {date}" subtitle line.
      expect(find.textContaining('Paid'), findsNWidgets(4));
    });
  });
}
