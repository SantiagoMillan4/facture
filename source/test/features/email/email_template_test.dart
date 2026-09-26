import 'package:facture/features/email/domain/email_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmailTemplate.render', () {
    final values = EmailTemplate.values(
      invoiceNumber: '2026-0042',
      clientName: 'Café Olimpico',
      amount: '115,47 \$',
      dueDate: '2026-10-15',
      issueDate: '2026-09-25',
      businessName: 'Santiago Millan',
    );

    test('replaces every known placeholder', () {
      const template =
          '{invoice_number} | {client_name} | {amount} | '
          '{due_date} | {issue_date} | {business_name}';
      expect(
        EmailTemplate.render(template, values),
        '2026-0042 | Café Olimpico | 115,47 \$ | '
        '2026-10-15 | 2026-09-25 | Santiago Millan',
      );
    });

    test('leaves unknown placeholders untouched', () {
      expect(
        EmailTemplate.render('Hello {client_name} {oops}', values),
        'Hello Café Olimpico {oops}',
      );
    });

    test('plain text without placeholders passes through', () {
      expect(EmailTemplate.render('Bonjour!', values), 'Bonjour!');
    });
  });

  test('JSON round trip', () {
    const template = EmailTemplate(
      subject: 'Facture {invoice_number}',
      body: 'Bonjour {client_name}',
    );
    expect(EmailTemplate.fromJson(template.toJson()), template);
  });
}
