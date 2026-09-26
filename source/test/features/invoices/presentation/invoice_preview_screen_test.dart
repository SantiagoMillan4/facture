import 'package:facture/features/clients/application/clients_providers.dart';
import 'package:facture/features/clients/domain/client.dart';
import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/features/invoices/presentation/invoice_preview_screen.dart';
import 'package:facture/features/invoices/presentation/invoices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender_platform_interface/flutter_email_sender_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_app.dart';
import '../../../test_helpers.dart';

/// Records composer requests instead of opening the native mail UI.
class _FakeEmailSender extends FlutterEmailSenderPlatform {
  final List<Email> sentEmails = [];

  @override
  Future<void> send(Email email) async {
    sentEmails.add(email);
  }

  @override
  Future<EmailCapabilities> getCapabilities() async =>
      const EmailCapabilities(
        canSend: true,
        supportsCc: true,
        supportsBcc: true,
        supportsSubject: true,
        supportsPlainTextBody: true,
        supportsHtmlBody: true,
        supportsAttachments: true,
      );
}

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
      await container.read(invoicesProvider.notifier).saveInvoice(
            sampleInvoice(),
          );
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
    testWidgets('shows the invoice number, PDF preview and send button',
        (tester) async {
      await seed(
        tester,
        const InvoicePreviewScreen(invoiceId: 'i1'),
      );

      expect(find.text('2026-0001'), findsOneWidget);
      expect(find.byType(PdfPreview), findsOneWidget);
      expect(find.text('Send invoice'), findsOneWidget);
      // The PDF actually rendered (pure-Dart raster, no platform channel).
      await pumpFrames(tester);
      expect(find.byType(PdfPreview), findsOneWidget);
    });

    testWidgets('edit button opens the invoice form', (tester) async {
      await seed(
        tester,
        const InvoicePreviewScreen(invoiceId: 'i1'),
      );

      await tester.tap(find.byTooltip('Edit invoice'));
      await pumpFrames(tester);

      expect(find.byType(InvoiceFormScreen), findsOneWidget);
    });

    testWidgets('send opens the composer with client, subject and PDF',
        (tester) async {
      // The plugin's native registrant never runs in tests, so its platform
      // instance is unimplemented — swap in a fake that records requests.
      final original = FlutterEmailSenderPlatform.instance;
      final fake = _FakeEmailSender();
      FlutterEmailSenderPlatform.instance = fake;
      addTearDown(() => FlutterEmailSenderPlatform.instance = original);

      await seed(
        tester,
        const InvoicePreviewScreen(invoiceId: 'i1'),
      );

      // The composer flow does real async work (PDF render + temp file
      // write), so the tap and the wait run in the real async zone —
      // starting the chain in fake async wedges it at the first microtask.
      await tester.runAsync(() async {
        await tester.tap(find.text('Send invoice'));
        for (var i = 0; i < 100 && fake.sentEmails.isEmpty; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
      });
      await pumpFrames(tester);

      expect(fake.sentEmails, hasLength(1));
      final email = fake.sentEmails.single;
      expect(email.recipients, contains('alice@example.com'));
      expect(email.subject, contains('2026-0001'));
      // The rendered template body mentions the client and the amount.
      expect(email.body, contains('Alice Tremblay'));
      final attachments = email.attachmentPaths ?? [];
      expect(attachments, hasLength(1));
      expect(attachments.single.endsWith('.pdf'), isTrue);
    });

    testWidgets('shows a message when the invoice was deleted',
        (tester) async {
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

      expect(find.text('Envoyer la facture'), findsOneWidget);
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
      expect(find.text('Send invoice'), findsOneWidget);
    });
  });
}
