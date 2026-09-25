/// Invoice domain model.
///
/// An invoice bills a client ([clientId]) for a list of [lines]. Tax amounts
/// (TPS/TVQ) are computed by `quebec_tax.dart` — never stored, always derived
/// — so totals stay consistent with the current tax rules.
///
/// Invoices live on-device only (local-first): the repository persists them
/// as JSON in SharedPreferences. No account, no cloud.
///
/// Code identifiers stay in English; user-facing strings go through l10n
/// (French-first).
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

  /// Past [Invoice.dueDate] and unpaid. Derived, not stored: see
  /// [Invoice.effectiveStatus].
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

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'quantity': quantity,
    'unitPrice': unitPrice,
  };

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      InvoiceLineItem(
        id: json['id'] as String,
        description: json['description'] as String? ?? '',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceLineItem &&
          id == other.id &&
          description == other.description &&
          quantity == other.quantity &&
          unitPrice == other.unitPrice;

  @override
  int get hashCode => Object.hash(id, description, quantity, unitPrice);
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
    this.chargeTaxes = true,
    this.paidDate,
  });

  /// Internal id.
  final String id;

  /// Human-visible invoice number, e.g. "2026-0001". Uniqueness and
  /// sequencing are handled by the application layer.
  final String number;

  final String clientId;
  final DateTime issueDate;
  final DateTime dueDate;
  final List<InvoiceLineItem> lines;
  final InvoiceStatus status;
  final String notes;

  /// Whether this invoice charges TPS/TVQ. Snapshotted at creation: a
  /// small supplier (≤ $30k taxable sales, not registered) must not charge
  /// taxes, and registering later must not rewrite old invoices.
  final bool chargeTaxes;

  /// When the invoice was marked paid. Set by the application layer on the
  /// draft/sent → paid transition; null otherwise.
  final DateTime? paidDate;

  /// The status to display: a sent invoice past its due date reads as
  /// overdue. Date-only comparison — an invoice due today is not overdue.
  InvoiceStatus get effectiveStatus {
    if (status != InvoiceStatus.sent) return status;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today) ? InvoiceStatus.overdue : InvoiceStatus.sent;
  }

  /// Pre-tax total of all lines.
  double get subtotal =>
      lines.fold(0.0, (sum, line) => sum + line.subtotal);

  /// Full TPS/TVQ breakdown for this invoice's lines, derived from the
  /// Québec tax rules — never stored.
  ///
  /// [rates] are user-editable; the user is responsible for the rates on
  /// their invoices. Pass [chargeTaxes] to override the snapshot (tests).
  InvoiceTaxes taxes({
    QuebecTaxRates rates = const QuebecTaxRates(),
    bool? chargeTaxes,
  }) => taxesForInvoice(
    lines.map((line) => dollarsToCents(line.subtotal)),
    rates: rates,
    chargeTaxes: chargeTaxes ?? this.chargeTaxes,
  );

  Invoice copyWith({
    String? id,
    String? number,
    String? clientId,
    DateTime? issueDate,
    DateTime? dueDate,
    List<InvoiceLineItem>? lines,
    InvoiceStatus? status,
    String? notes,
    bool? chargeTaxes,
    DateTime? paidDate,
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
      chargeTaxes: chargeTaxes ?? this.chargeTaxes,
      paidDate: paidDate ?? this.paidDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'clientId': clientId,
    'issueDate': issueDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'lines': lines.map((l) => l.toJson()).toList(),
    'status': status.name,
    'notes': notes,
    'chargeTaxes': chargeTaxes,
    'paidDate': paidDate?.toIso8601String(),
  };

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
    id: json['id'] as String,
    number: json['number'] as String? ?? '',
    clientId: json['clientId'] as String? ?? '',
    issueDate:
        DateTime.tryParse(json['issueDate'] as String? ?? '') ?? DateTime.now(),
    dueDate:
        DateTime.tryParse(json['dueDate'] as String? ?? '') ?? DateTime.now(),
    lines:
        (json['lines'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .map(InvoiceLineItem.fromJson)
            .toList() ??
        const [],
    status: InvoiceStatus.values.asNameMap()[json['status'] as String?] ??
        InvoiceStatus.draft,
    notes: json['notes'] as String? ?? '',
    chargeTaxes: json['chargeTaxes'] as bool? ?? true,
    paidDate: json['paidDate'] == null
        ? null
        : DateTime.tryParse(json['paidDate'] as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Invoice &&
          id == other.id &&
          number == other.number &&
          clientId == other.clientId &&
          issueDate == other.issueDate &&
          dueDate == other.dueDate &&
          _linesEqual(lines, other.lines) &&
          status == other.status &&
          notes == other.notes &&
          chargeTaxes == other.chargeTaxes &&
          paidDate == other.paidDate;

  @override
  int get hashCode => Object.hash(
    id,
    number,
    clientId,
    issueDate,
    dueDate,
    Object.hashAll(lines),
    status,
    notes,
    chargeTaxes,
    paidDate,
  );
}

bool _linesEqual(List<InvoiceLineItem> a, List<InvoiceLineItem> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
