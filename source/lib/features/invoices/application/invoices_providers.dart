import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/invoices_repository.dart';
import '../domain/invoice.dart';

/// On-device invoice repository (SharedPreferences JSON document).
final invoicesRepositoryProvider = Provider<InvoicesRepository>((ref) {
  return InvoicesRepository();
});

/// The invoice book. Async because the first load reads from disk.
final invoicesProvider =
    AsyncNotifierProvider<InvoicesNotifier, List<Invoice>>(InvoicesNotifier.new);

class InvoicesNotifier extends AsyncNotifier<List<Invoice>> {
  @override
  Future<List<Invoice>> build() {
    return ref.watch(invoicesRepositoryProvider).loadInvoices();
  }

  /// Inserts a new invoice or replaces the one with the same id, then
  /// persists the whole book. [Invoice.paidDate] and [Invoice.sentDate]
  /// are maintained here: stamped on the transition to paid/sent,
  /// preserved while paid/sent, cleared when moved away. (Rebuilt rather
  /// than copyWith'd because copyWith cannot null dates out.)
  Future<void> saveInvoice(Invoice invoice) async {
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((i) => i.id == invoice.id);
    final previous = index >= 0 ? current[index] : null;

    final toSave = _withStampedDates(previous, invoice);

    final updated = List<Invoice>.of(current);
    if (index >= 0) {
      updated[index] = toSave;
    } else {
      updated.add(toSave);
    }
    await _persist(updated);
  }

  /// Moves an invoice to [status], stamping/clearing paidDate and sentDate
  /// like [saveInvoice] does. No-op when the status is unchanged.
  Future<void> setStatus(String id, InvoiceStatus status) async {
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((i) => i.id == id);
    if (index < 0) return;
    final previous = current[index];
    if (previous.status == status) return;
    final updated = List<Invoice>.of(current);
    updated[index] = _withStampedDates(
      previous,
      previous.copyWith(status: status),
    );
    await _persist(updated);
  }

  /// Rebuilds [invoice] with paidDate/sentDate stamped from [previous]
  /// according to its status: paid keeps (or stamps) paidDate; sent keeps
  /// (or stamps) sentDate and drops paidDate; draft drops both.
  Invoice _withStampedDates(Invoice? previous, Invoice invoice) {
    final now = DateTime.now();
    switch (invoice.status) {
      case InvoiceStatus.paid:
        return Invoice(
          id: invoice.id,
          number: invoice.number,
          clientId: invoice.clientId,
          issueDate: invoice.issueDate,
          dueDate: invoice.dueDate,
          lines: invoice.lines,
          status: invoice.status,
          notes: invoice.notes,
          chargeTaxes: invoice.chargeTaxes,
          paidDate: previous?.paidDate ?? now,
          sentDate: previous?.sentDate,
        );
      case InvoiceStatus.sent:
        return Invoice(
          id: invoice.id,
          number: invoice.number,
          clientId: invoice.clientId,
          issueDate: invoice.issueDate,
          dueDate: invoice.dueDate,
          lines: invoice.lines,
          status: invoice.status,
          notes: invoice.notes,
          chargeTaxes: invoice.chargeTaxes,
          sentDate: previous?.sentDate ?? now,
        );
      case InvoiceStatus.draft:
      case InvoiceStatus.overdue:
        // overdue is derived, never stored; a stored overdue is treated
        // as sent for its dates.
        final asSent = invoice.status == InvoiceStatus.overdue;
        return Invoice(
          id: invoice.id,
          number: invoice.number,
          clientId: invoice.clientId,
          issueDate: invoice.issueDate,
          dueDate: invoice.dueDate,
          lines: invoice.lines,
          status: asSent ? InvoiceStatus.sent : invoice.status,
          notes: invoice.notes,
          chargeTaxes: invoice.chargeTaxes,
          sentDate: asSent ? (previous?.sentDate ?? now) : null,
        );
    }
  }

  Future<void> deleteInvoice(String id) async {
    final current = state.valueOrNull ?? [];
    await _persist(current.where((i) => i.id != id).toList());
  }

  Future<void> _persist(List<Invoice> updated) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(invoicesRepositoryProvider).saveInvoices(updated);
      return updated;
    });
  }
}

/// Generates a unique invoice id. Local-only: a timestamp is unique enough
/// for an on-device invoice book.
String newInvoiceId() => 'i${DateTime.now().microsecondsSinceEpoch}';

/// Next human-visible invoice number: `YYYY-NNNN`, sequencing within the
/// current year from the highest existing number. Numbers the user edited
/// into another shape are ignored for sequencing (never parsed as numbers
/// the user didn't intend).
String nextInvoiceNumber(List<Invoice> invoices) {
  final year = DateTime.now().year;
  var maxSeq = 0;
  final pattern = RegExp('^$year-(\\d+)\$');
  for (final invoice in invoices) {
    final match = pattern.firstMatch(invoice.number);
    if (match != null) {
      final seq = int.tryParse(match.group(1)!) ?? 0;
      if (seq > maxSeq) maxSeq = seq;
    }
  }
  return '$year-${(maxSeq + 1).toString().padLeft(4, '0')}';
}
