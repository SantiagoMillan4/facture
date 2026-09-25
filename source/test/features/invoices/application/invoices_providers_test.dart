import 'package:facture/features/invoices/application/invoices_providers.dart';
import 'package:facture/features/invoices/domain/invoice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
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

  Future<({ProviderContainer container, InvoicesNotifier notifier})>
      seeded() async {
    SharedPreferences.setMockInitialValues({});
    final container = makeContainer();
    final notifier = container.read(invoicesProvider.notifier);
    await container.read(invoicesProvider.future);
    await notifier.saveInvoice(draftInvoice());
    return (container: container, notifier: notifier);
  }

  Invoice saved(ProviderContainer container) =>
      container.read(invoicesProvider).value!.single;

  group('InvoicesNotifier.setStatus', () {
    test('draft -> sent stamps sentDate, leaves paidDate null', () async {
      final (:container, :notifier) = await seeded();

      await notifier.setStatus('i1', InvoiceStatus.sent);

      final invoice = saved(container);
      expect(invoice.status, InvoiceStatus.sent);
      expect(invoice.sentDate, isNotNull);
      expect(invoice.paidDate, isNull);
    });

    test('sent -> paid stamps paidDate and keeps sentDate', () async {
      final (:container, :notifier) = await seeded();

      await notifier.setStatus('i1', InvoiceStatus.sent);
      final sentAt = saved(container).sentDate;
      await notifier.setStatus('i1', InvoiceStatus.paid);

      final invoice = saved(container);
      expect(invoice.status, InvoiceStatus.paid);
      expect(invoice.paidDate, isNotNull);
      expect(invoice.sentDate, sentAt);
    });

    test('paid -> sent clears paidDate and keeps sentDate', () async {
      final (:container, :notifier) = await seeded();

      await notifier.setStatus('i1', InvoiceStatus.sent);
      final sentAt = saved(container).sentDate;
      await notifier.setStatus('i1', InvoiceStatus.paid);
      await notifier.setStatus('i1', InvoiceStatus.sent);

      final invoice = saved(container);
      expect(invoice.status, InvoiceStatus.sent);
      expect(invoice.paidDate, isNull);
      expect(invoice.sentDate, sentAt);
    });

    test('paid -> draft clears both dates', () async {
      final (:container, :notifier) = await seeded();

      await notifier.setStatus('i1', InvoiceStatus.paid);
      await notifier.setStatus('i1', InvoiceStatus.draft);

      final invoice = saved(container);
      expect(invoice.status, InvoiceStatus.draft);
      expect(invoice.paidDate, isNull);
      expect(invoice.sentDate, isNull);
    });

    test('same status is a no-op and preserves stamped dates', () async {
      final (:container, :notifier) = await seeded();

      await notifier.setStatus('i1', InvoiceStatus.paid);
      final before = saved(container);
      await notifier.setStatus('i1', InvoiceStatus.paid);

      final after = saved(container);
      expect(after, before);
      expect(after.paidDate, before.paidDate);
    });

    test('unknown id is a no-op', () async {
      final (:container, :notifier) = await seeded();
      final before = container.read(invoicesProvider).value;

      await notifier.setStatus('nope', InvoiceStatus.paid);

      expect(container.read(invoicesProvider).value, before);
    });

    test('saveInvoice stamps sentDate when saved as sent', () async {
      final (:container, :notifier) = await seeded();

      await notifier.saveInvoice(
        draftInvoice().copyWith(status: InvoiceStatus.sent),
      );

      final invoice = saved(container);
      expect(invoice.status, InvoiceStatus.sent);
      expect(invoice.sentDate, isNotNull);
      expect(invoice.paidDate, isNull);
    });
  });
}
