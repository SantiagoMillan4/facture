import 'package:facture/features/clients/application/clients_providers.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Finder fieldByLabel(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byType(TextFormField),
);

void main() {
  late ProviderContainer container;

  Future<void> pumpForm(
    WidgetTester tester, {
    Invoice? invoice,
    Locale? locale,
  }) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return InvoiceFormScreen(invoice: invoice);
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> seedClient() async {
    await container
        .read(clientsProvider.notifier)
        .saveClient(const Client(id: 'c1', name: 'Alice Tremblay'));
  }

  Future<void> pickSeededClient(WidgetTester tester) async {
    await seedClient();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select a client'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alice Tremblay'));
    await tester.pumpAndSettle();
  }

  Future<void> fillFirstLine(
    WidgetTester tester, {
    String description = 'Design',
    String qty = '1',
    String price = '100',
    String descriptionLabel = 'Description',
    String qtyLabel = 'Qty',
    String priceLabel = 'Unit price',
  }) async {
    await tester.enterText(fieldByLabel(descriptionLabel), description);
    await tester.enterText(fieldByLabel(qtyLabel), qty);
    await tester.enterText(fieldByLabel(priceLabel), price);
    await tester.pump();
  }

  group('InvoiceFormScreen', () {
    testWidgets('renders with the next invoice number prefilled', (
      tester,
    ) async {
      await pumpForm(tester);
      final year = DateTime.now().year;

      expect(find.text('New invoice'), findsOneWidget);
      expect(find.text('$year-0001'), findsOneWidget);
      expect(find.text('Select a client'), findsOneWidget);
      expect(find.text('Add line', skipOffstage: false), findsOneWidget);
    });

    testWidgets('requires a client and a valid line before saving', (
      tester,
    ) async {
      await pumpForm(tester);

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Please select a client.'), findsOneWidget);
      expect(find.text('Add at least one line item.', skipOffstage: false), findsOneWidget);
      expect(container.read(invoicesProvider).valueOrNull, isEmpty);
    });

    testWidgets('live totals show the Québec TPS/TVQ breakdown', (
      tester,
    ) async {
      await pumpForm(tester);
      await fillFirstLine(tester);

      expect(find.text('\$100.00', skipOffstage: false), findsWidgets);
      expect(find.text('TPS (5 %)', skipOffstage: false), findsOneWidget);
      expect(find.text('\$5.00', skipOffstage: false), findsOneWidget);
      expect(find.text('TVQ (9,975 %)', skipOffstage: false), findsOneWidget);
      expect(find.text('\$10.47', skipOffstage: false), findsOneWidget);
      expect(find.text('\$115.47', skipOffstage: false), findsOneWidget);
    });

    testWidgets('turning taxes off hides the tax rows', (tester) async {
      await pumpForm(tester);
      await fillFirstLine(tester);

      final taxSwitch = find.byType(SwitchListTile);
      await tester.ensureVisible(taxSwitch);
      await tester.pumpAndSettle();
      await tester.tap(taxSwitch);
      await tester.pump();

      expect(find.text('TPS (5 %)', skipOffstage: false), findsNothing);
      expect(find.text('TVQ (9,975 %)', skipOffstage: false), findsNothing);
      // Subtotal and total read the same.
      expect(find.text('\$100.00', skipOffstage: false), findsWidgets);
    });

    testWidgets('saves a complete invoice to the on-device book', (
      tester,
    ) async {
      await pumpForm(tester);
      await pickSeededClient(tester);
      await fillFirstLine(tester);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final invoices = container.read(invoicesProvider).valueOrNull ?? [];
      expect(invoices, hasLength(1));
      final saved = invoices.single;
      expect(saved.clientId, 'c1');
      expect(saved.lines, hasLength(1));
      expect(saved.lines.single.description, 'Design');
      expect(saved.lines.single.quantity, 1);
      expect(saved.lines.single.unitPrice, 100);
      expect(saved.status, InvoiceStatus.draft);
      expect(saved.taxes().totalCents, 11547);
      // Back on the previous screen after saving.
      expect(find.byType(InvoiceFormScreen), findsNothing);
    });

    testWidgets('editing an invoice pre-fills its values', (tester) async {
      final invoice = Invoice(
        id: 'i1',
        number: '2026-0042',
        clientId: 'c1',
        issueDate: DateTime(2026, 9, 1),
        dueDate: DateTime(2026, 10, 1),
        lines: const [
          InvoiceLineItem(
            id: 'l1',
            description: 'Consulting',
            quantity: 2,
            unitPrice: 75,
          ),
        ],
        status: InvoiceStatus.sent,
        notes: 'Net 30',
      );
      await pumpForm(tester, invoice: invoice);
      await seedClient();
      await tester.pumpAndSettle();

      expect(find.text('Edit invoice'), findsOneWidget);
      expect(find.text('2026-0042'), findsOneWidget);
      expect(find.text('Consulting'), findsOneWidget);
      expect(find.text('Alice Tremblay'), findsOneWidget);
      // 2 × 75 = 150 + TPS 7.50 + TVQ 15.71 = 173.21
      expect(find.text('\$173.21', skipOffstage: false), findsOneWidget);
    });

    testWidgets('French locale renders French labels and amounts', (
      tester,
    ) async {
      await pumpForm(tester, locale: const Locale('fr'));
      await fillFirstLine(
        tester,
        descriptionLabel: 'Description',
        qtyLabel: 'Qté',
        priceLabel: 'Prix unitaire',
      );

      expect(find.text('Nouvelle facture'), findsOneWidget);
      expect(find.text('Choisir un client'), findsOneWidget);
      expect(find.text('115,47\u202f\$', skipOffstage: false), findsOneWidget);
    });
  });
}
