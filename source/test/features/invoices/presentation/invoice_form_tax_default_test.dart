import 'dart:convert';

import 'package:facture/features/business/data/business_profile_repository.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/invoices/presentation/invoice_form_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The invoice form's tax default must follow the declared business
/// profile: registered → taxes on, small supplier → taxes off, and no
/// profile → taxes off (registration is never assumed).
void main() {
  Future<void> pumpForm(WidgetTester tester, {BusinessProfile? profile}) async {
    SharedPreferences.setMockInitialValues({
      if (profile != null)
        BusinessProfileRepository.storageKey: jsonEncode(profile.toJson()),
    });
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const InvoiceFormScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  bool taxesToggleValue(WidgetTester tester) {
    final toggle = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Charge TPS/TVQ'),
    );
    return toggle.value;
  }

  testWidgets('taxes default OFF when no business profile exists', (
    tester,
  ) async {
    await pumpForm(tester);
    expect(taxesToggleValue(tester), isFalse);
  });

  testWidgets('taxes default ON when profile is registered', (tester) async {
    await pumpForm(
      tester,
      profile: const BusinessProfile(
        name: 'Atelier Nord',
        taxStatus: TaxRegistrationStatus.registered,
      ),
    );
    expect(taxesToggleValue(tester), isTrue);
  });

  testWidgets('taxes default OFF when profile is a small supplier', (
    tester,
  ) async {
    await pumpForm(
      tester,
      profile: const BusinessProfile(
        name: 'Atelier Nord',
        taxStatus: TaxRegistrationStatus.smallSupplier,
      ),
    );
    expect(taxesToggleValue(tester), isFalse);
  });

  testWidgets('profile nudge shows when no profile exists', (tester) async {
    await pumpForm(tester);
    expect(find.text('Set up'), findsOneWidget);
  });

  testWidgets('profile nudge hidden once the profile is set up', (
    tester,
  ) async {
    await pumpForm(
      tester,
      profile: const BusinessProfile(name: 'Atelier Nord'),
    );
    expect(find.text('Set up'), findsNothing);
  });
}
