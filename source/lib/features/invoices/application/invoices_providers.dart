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
  /// persists the whole book. [Invoice.paidDate] is maintained here:
  /// stamped on the transition to paid, preserved while paid, cleared
  /// when moved away from paid. (Rebuilt rather than copyWith'd because
  /// copyWith cannot null paidDate out.)
  Future<void> saveInvoice(Invoice invoice) async {
    final current = state.valueOrNull ?? [];
    final index = current.indexWhere((i) => i.id == invoice.id);
    final previous = index >= 0 ? current[index] : null;
    final isPaid = invoice.status == InvoiceStatus.paid;

    final toSave = Invoice(
      id: invoice.id,
      number: invoice.number,
      clientId: invoice.clientId,
      issueDate: invoice.issueDate,
      dueDate: invoice.dueDate,
      lines: invoice.lines,
      status: invoice.status,
      notes: invoice.notes,
      chargeTaxes: invoice.chargeTaxes,
      paidDate: isPaid ? (previous?.paidDate ?? DateTime.now()) : null,
    );

    final updated = List<Invoice>.of(current);
    if (index >= 0) {
      updated[index] = toSave;
    } else {
      updated.add(toSave);
    }
    await _persist(updated);
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
