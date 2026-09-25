/// French/English strings for the invoice PDF.
///
/// The pdf package is pure Dart, so these live here rather than in the
/// Flutter l10n delegates.
/// PDF-localized strings (the pdf package is pure Dart, so these live
/// here rather than in the Flutter l10n delegates).
class InvoicePdfStrings {
  InvoicePdfStrings(this.french);

  final bool french;

  String get invoiceTitle => french ? 'FACTURE' : 'INVOICE';
  String get issueDate => french ? 'Date d\u2019\u00e9mission' : 'Issue date';
  String get dueDate => french ? 'Date d\u2019\u00e9ch\u00e9ance' : 'Due date';
  String get paidOn => french ? 'Pay\u00e9e le' : 'Paid on';
  String get billTo => french ? 'FACTUR\u00c9 \u00c0' : 'BILL TO';
  String get description => french ? 'Description' : 'Description';
  String get quantity => french ? 'Qt\u00e9' : 'Qty';
  String get unitPrice => french ? 'Prix unitaire' : 'Unit price';
  String get amount => french ? 'Montant' : 'Amount';
  String get subtotal => french ? 'Sous-total' : 'Subtotal';
  String get total => french ? 'Total' : 'Total';
  String get notes => french ? 'Notes' : 'Notes';
}
