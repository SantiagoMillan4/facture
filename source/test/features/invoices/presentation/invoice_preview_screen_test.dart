import 'package:facture/features/clients/application/clients_providers.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/invoices/presentation/invoice_preview_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_app.dart';
import '../../../test_helpers.dart';

void main() {
  setUpPrintingMock();

  Invoice sampleInvoice() => Invoice(
    id: 'i1',
    number: '2026-0001',
    clientId: 'c1',
    issueDate: DateTime(2026, 9, 1),
    dueDate: DateTime(2026, 10, 1),
    status: InvoiceStatus.draft,
    lines: const [
      InvoiceLineItem(
        id: 'l1',
        description: 'Design',
        quantity: 1,
        unitPrice: 100,
      ),
    ],
  );

  const sampleClient = Client(
    id: 'c1',
    name: 'Alice Tremblay',
    email: 'alice@example.com',
  );

  /// Pumps without [pumpAndSettle]: once the [PdfPreview] is on screen its
  /// indeterminate loading spinner schedules frames forever in tests (the
  /// native rasterizer doesn't exist here), so settling would time out.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Future<ProviderContainer> seed(
    WidgetTester tester,
    Widget child, {
    bool withInvoice = true,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(invoicesProvider.future);
    await container.read(clientsProvider.future);
    await container.read(clientsProvider.notifier).saveClient(sampleClient);
    if (withInvoice) {
      await container
          .read(invoicesProvider.notifier)
          .saveInvoice(sampleInvoice());
    }
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(child: child),
      ),
    );
    await pumpFrames(tester);
    return container;
  }

  group('InvoicePreviewScreen', () {
    testWidgets('shows the invoice number, PDF preview and share button', (
      tester,
    ) async {
      await seed(tester, const InvoicePreviewScreen(invoiceId: 'i1'));

      expect(find.text('2026-0001'), findsOneWidget);
      expect(find.byType(PdfPreview), findsOneWidget);
      expect(find.text('Share PDF'), findsOneWidget);
      // The PDF actually rendered (pure-Dart raster, no platform channel).
      await pumpFrames(tester);
      expect(find.byType(PdfPreview), findsOneWidget);
    });

    testWidgets('edit button opens the invoice form', (tester) async {
      await seed(tester, const InvoicePreviewScreen(invoiceId: 'i1'));

      await tester.tap(find.byTooltip('Edit invoice'));
      await pumpFrames(tester);

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('shows a message when the invoice was deleted', (tester) async {
      await seed(
        tester,
        const InvoicePreviewScreen(invoiceId: 'i1'),
        withInvoice: false,
      );

      expect(find.text('This invoice no longer exists.'), findsOneWidget);
    });

    testWidgets('French strings are used in French locale', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(invoicesProvider.future);
      await container.read(clientsProvider.future);
      await container.read(clientsProvider.notifier).saveClient(sampleClient);
      await container
          .read(invoicesProvider.notifier)
          .saveInvoice(sampleInvoice());

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            locale: const Locale('fr'),
            child: const InvoicePreviewScreen(invoiceId: 'i1'),
          ),
        ),
      );
      await pumpFrames(tester);

      expect(find.text('Partager le PDF'), findsOneWidget);
      expect(find.byTooltip('Modifier la facture'), findsOneWidget);
    });
  });

  group('InvoicesScreen navigation', () {
    testWidgets('tapping an invoice row opens the preview', (tester) async {
      await seed(tester, const InvoicesScreen());

      await tester.tap(find.text('2026-0001'));
      await pumpFrames(tester);

      expect(find.byType(InvoicePreviewScreen), findsOneWidget);
      expect(find.byType(InvoiceFormScreen), findsNothing);
      expect(find.text('Share PDF'), findsOneWidget);
    });
  });
}
