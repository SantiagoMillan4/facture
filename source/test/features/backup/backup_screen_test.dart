import 'package:facture/features/backup/presentation/backup_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<void> pumpScreen(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BackupScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows backup and export actions', (tester) async {
    await pumpScreen(tester);

    expect(find.text('Backup & export'), findsOneWidget);
    expect(find.text('Export backup'), findsOneWidget);
    expect(find.text('Import backup'), findsOneWidget);
    expect(find.text('Invoices (CSV)'), findsOneWidget);
  });
}
