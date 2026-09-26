import 'package:facture/features/email/application/email_template_providers.dart';
import 'package:facture/features/email/presentation/email_template_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;

  Future<void> pumpScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return const EmailTemplateScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder fieldByLabel(String label) => find.ancestor(
    of: find.text(label),
    matching: find.byType(TextFormField),
  );

  testWidgets('loads the default template, inserts placeholders, saves', (
    tester,
  ) async {
    await pumpScreen(tester);

    String textOf(Finder field) =>
        (tester.widget(field) as TextFormField).controller!.text;

    // Localized default prefilled (tests run in English).
    expect(textOf(fieldByLabel('Subject')), contains('{invoice_number}'));

    // Tapping a placeholder chip inserts it into the focused field.
    await tester.tap(fieldByLabel('Message'));
    await tester.pump();
    await tester.tap(find.text('{amount}'));
    await tester.pump();
    expect(textOf(fieldByLabel('Message')), contains('{amount}'));

    // Save persists the edited template.
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final saved = await container.read(emailTemplateProvider.future);
    expect(saved?.body, contains('{amount}'));
    expect(saved?.subject, contains('{invoice_number}'));
  });
}
