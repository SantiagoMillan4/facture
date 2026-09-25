import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_app.dart';

void main() {
  Future<void> pumpInvoices(WidgetTester tester, {Locale? locale}) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: TestApp(
          locale: locale,
          child: const InvoicesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('InvoicesScreen', () {
    testWidgets('shows app bar, empty state action and add button',
        (tester) async {
      await pumpInvoices(tester);

      expect(find.text('Invoices'), findsOneWidget);
      expect(find.text('New invoice'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('empty-state action opens the invoice form',
        (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.text('New invoice'));
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('FAB opens the invoice form', (tester) async {
      await pumpInvoices(tester);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('French strings are used in French locale', (tester) async {
      await pumpInvoices(tester, locale: const Locale('fr'));

      expect(find.text('Factures'), findsOneWidget);
      expect(find.text('Nouvelle facture'), findsOneWidget);
    });
  });

  group('status workflow', () {
    Future<ProviderContainer> seedInvoice(
      WidgetTester tester,
      Invoice invoice,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(invoicesProvider.notifier);
      await container.read(invoicesProvider.future);
      await notifier.saveInvoice(invoice);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(child: const InvoicesScreen()),
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

    testWidgets('tapping the status chip offers the draft transitions',
        (tester) async {
      await seedInvoice(tester, draftInvoice());

      await tester.tap(find.text('Draft'));
      await tester.pumpAndSettle();

      expect(find.text('Change status'), findsOneWidget);
      expect(find.text('Mark as sent'), findsOneWidget);
      expect(find.text('Mark as paid'), findsOneWidget);
      expect(find.text('Back to draft'), findsNothing);
    });

    testWidgets('marking as sent updates the chip and stamps the date',
        (tester) async {
      final container = await seedInvoice(tester, draftInvoice());

      await tester.tap(find.text('Draft'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as sent'));
      await tester.pumpAndSettle();

      expect(find.text('Sent'), findsOneWidget);
      expect(
        container.read(invoicesProvider).value!.single.sentDate,
        isNotNull,
      );
    });

    testWidgets('paid invoice tile shows the paid date', (tester) async {
      await seedInvoice(
        tester,
        draftInvoice().copyWith(
          status: InvoiceStatus.paid,
          paidDate: DateTime(2026, 9, 20),
        ),
      );

      // Status chip plus the "Paid {date}" subtitle line.
      expect(find.textContaining('Paid'), findsNWidgets(2));
    });
  });
}
