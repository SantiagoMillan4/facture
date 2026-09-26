/// Editable email template used when sending an invoice to a client.
///
/// The template's [subject] and [body] support placeholders, replaced when
/// the email is composed:
///
/// * `{invoice_number}` — e.g. `2026-0042`
/// * `{client_name}` — the billed client's name
/// * `{amount}` — the invoice total, locale-formatted with cents
/// * `{due_date}` — ISO date, e.g. `2026-10-15`
/// * `{issue_date}` — ISO date
/// * `{business_name}` — the freelancer's business name, if set
///
/// Unknown placeholders are left untouched so a typo stays visible instead
/// of silently vanishing. Stored on-device only (SharedPreferences JSON).
library;

/// A user-editable subject/body pair for invoice emails.
class EmailTemplate {
  const EmailTemplate({required this.subject, required this.body});

  final String subject;
  final String body;

  /// Values available to templates, keyed by placeholder name.
  static Map<String, String> values({
    required String invoiceNumber,
    required String clientName,
    required String amount,
    required String dueDate,
    required String issueDate,
    required String businessName,
  }) => {
    'invoice_number': invoiceNumber,
    'client_name': clientName,
    'amount': amount,
    'due_date': dueDate,
    'issue_date': issueDate,
    'business_name': businessName,
  };

  /// Replaces `{placeholder}` occurrences in [template] with [values].
  /// Placeholders with no matching value are left as-is.
  static String render(String template, Map<String, String> values) {
    var result = template;
    values.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  Map<String, dynamic> toJson() => {'subject': subject, 'body': body};

  factory EmailTemplate.fromJson(Map<String, dynamic> json) => EmailTemplate(
    subject: json['subject'] as String? ?? '',
    body: json['body'] as String? ?? '',
  );

  /// The starter template, localized. Applies until the user customizes it.
  ///
  /// Kept in code (not ARB) because the `{placeholder}` tokens must survive
  /// verbatim — gen-l10n parses them as message arguments.
  static EmailTemplate defaults({required bool french}) {
    if (french) {
      return const EmailTemplate(
        subject: 'Facture {invoice_number} — {business_name}',
        body:
            'Bonjour {client_name},\n'
            '\n'
            "La facture {invoice_number} d'un montant de {amount} "
            'est à payer avant le {due_date}.\n'
            '\n'
            'Merci!\n'
            '{business_name}',
      );
    }
    return const EmailTemplate(
      subject: 'Invoice {invoice_number} — {business_name}',
      body:
          'Hello {client_name},\n'
          '\n'
          'Invoice {invoice_number} for {amount} is due by {due_date}.\n'
          '\n'
          'Thank you!\n'
          '{business_name}',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailTemplate &&
          subject == other.subject &&
          body == other.body;

  @override
  int get hashCode => Object.hash(subject, body);
}
