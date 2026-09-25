/// Invoice domain model (scaffold stub).
///
/// An invoice bills a client ([clientId]) for a list of [lines]. Tax amounts
/// (TPS/TVQ) are computed by `quebec_tax.dart` — never stored, always derived
/// — so totals stay consistent with the current tax rules.
///
/// Code identifiers stay in English; user-facing strings go through l10n
/// (French-first).
///
/// TODO: wire tax totals through quebec_tax.dart once the rules are
/// implemented; add persistence + invoice numbering.
library;

import 'quebec_tax.dart';

/// Lifecycle of an invoice.
enum InvoiceStatus {
  /// Being edited, not sent to the client yet.
  draft,

  /// Sent to the client, awaiting payment.
  sent,

  /// Paid in full.
  paid,

  /// Past [Invoice.dueDate] and unpaid.
  overdue,
}

/// One billable line on an invoice.
class InvoiceLineItem {
  const InvoiceLineItem({
    required this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  final String id;
  final String description;
  final double quantity;
  final double unitPrice;

  /// Pre-tax line subtotal. Cent-rounding happens per line inside
  /// `quebec_tax.dart` (Québec rule) — not here, not on the invoice total.
  double get subtotal => quantity * unitPrice;

  InvoiceLineItem copyWith({
    String? id,
    String? description,
    double? quantity,
    double? unitPrice,
  }) {
    return InvoiceLineItem(
      id: id ?? this.id,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

/// A freelancer's invoice to a client.
class Invoice {
  const Invoice({
    required this.id,
    required this.number,
    required this.clientId,
    required this.issueDate,
    required this.dueDate,
    this.lines = const <InvoiceLineItem>[],
    this.status = InvoiceStatus.draft,
    this.notes = '',
  });

  /// Internal id (uuid).
  final String id;

  /// Human-visible invoice number, e.g. "2026-001". Uniqueness and
  /// sequencing are enforced by the application layer.
  /// TODO: invoice numbering strategy (per-year sequences).
  final String number;

  final String clientId;
  final DateTime issueDate;
  final DateTime dueDate;
  final List<InvoiceLineItem> lines;
  final InvoiceStatus status;
  final String notes;

  /// Pre-tax total of all lines.
  double get subtotal =>
      lines.fold(0.0, (sum, line) => sum + line.subtotal);

  /// Full TPS/TVQ breakdown for this invoice's lines, derived from the
  /// Québec tax rules — never stored.
  ///
  /// [chargeTaxes] comes from the seller's tax profile (application layer):
  /// false for a small supplier (≤ $30k taxable sales, not registered),
  /// who must not charge TPS/TVQ. [rates] are user-editable; the user is
  /// responsible for the rates on their invoices.
  InvoiceTaxes taxes({
    QuebecTaxRates rates = const QuebecTaxRates(),
    required bool chargeTaxes,
  }) =>
      taxesForInvoice(
        lines.map((line) => dollarsToCents(line.subtotal)),
        rates: rates,
        chargeTaxes: chargeTaxes,
      );

  // TODO: isOverdue derived from status + dueDate vs today.

  Invoice copyWith({
    String? id,
    String? number,
    String? clientId,
    DateTime? issueDate,
    DateTime? dueDate,
    List<InvoiceLineItem>? lines,
    InvoiceStatus? status,
    String? notes,
  }) {
    return Invoice(
      id: id ?? this.id,
      number: number ?? this.number,
      clientId: clientId ?? this.clientId,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      lines: lines ?? this.lines,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
