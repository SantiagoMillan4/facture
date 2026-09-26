import 'dart:async';

import 'package:facture/features/business/application/business_profile_providers.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/onboarding/application/onboarding_service.dart';
import 'package:facture/features/onboarding/presentation/onboarding_screen.dart';
import 'package:facture/features/purchase/application/purchase_providers.dart';
import 'package:facture/features/purchase/data/purchase_service.dart';
import 'package:facture/features/purchase/domain/purchase_catalog.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePurchaseService implements PurchaseService {
  _FakePurchaseService({this.product});

  final StoreProduct? product;
  final _controller = StreamController<PurchaseUpdate>.broadcast();

  @override
  Future<StoreProduct?> loadProduct() async => product;

  @override
  Stream<PurchaseUpdate> get updates => _controller.stream;

  @override
  Future<void> buy(StoreProduct product) async {}

  @override
  Future<bool> restore() async => false;

  void emit(PurchaseUpdate update) => _controller.add(update);
}

const _proProduct = StoreProduct(
  id: PurchaseCatalog.proProductId,
  price: '32,99 \$',
);

/// Walks the first three steps and lands on the pricing step.
Future<void> _reachPricing(
  WidgetTester tester,
  _FakePurchaseService service,
  void Function() onDone,
) async {
  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(
    ProviderScope(
      overrides: [purchaseServiceProvider.overrideWithValue(service)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OnboardingScreen(onDone: onDone),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('Get started'));
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), 'Atelier Nord');
  await tester.tap(find.text('Small supplier'));
  await tester.pump();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();

  for (var i = 0; i < 3; i++) {
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
  }
  expect(find.text('Simple pricing'), findsOneWidget);
}

void main() {
  testWidgets('business setup requires a name and an explicit tax choice', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingScreen(onDone: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    expect(find.text('Your business'), findsOneWidget);

    // Empty submit goes nowhere.
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Your business'), findsOneWidget);
    expect(find.text('Enter your business name'), findsOneWidget);

    // Name alone is not enough: the tax status must be chosen explicitly.
    await tester.enterText(find.byType(TextField), 'Atelier Nord');
    await tester.tap(find.text('Continue'));
    await tester.pump();
    expect(find.text('Your business'), findsOneWidget);
    expect(find.text('Choose your tax status to continue'), findsOneWidget);

    // Choosing a status advances and persists the profile as declared.
    await tester.tap(find.text('Small supplier'));
    await tester.pump();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('How it works'), findsOneWidget);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(OnboardingScreen)),
    );
    final profile = await container.read(businessProfileProvider.future);
    expect(profile?.name, 'Atelier Nord');
    expect(profile?.taxStatus, TaxRegistrationStatus.smallSupplier);
  });

  testWidgets('Start free finishes onboarding and marks it done', (
    tester,
  ) async {
    var done = false;
    await _reachPricing(tester, _FakePurchaseService(product: _proProduct), () {
      done = true;
    });

    await tester.tap(find.text('Start free'));
    await tester.pumpAndSettle();

    expect(done, isTrue);
    expect(await OnboardingService.needsOnboarding(), isFalse);
  });

  testWidgets(
    'Get Facture Pro opens the paywall; purchase finishes onboarding',
    (tester) async {
      final service = _FakePurchaseService(product: _proProduct);
      var done = false;
      await _reachPricing(tester, service, () {
        done = true;
      });

      await tester.tap(find.text('Get Facture Pro'));
      await tester.pumpAndSettle();
      // String unique to the paywall sheet (not the pricing card).
      expect(find.text('Restore purchases'), findsOneWidget);

      service.emit(
        PurchaseUpdate(
          outcome: PurchaseOutcome.purchased,
          productId: PurchaseCatalog.proProductId,
        ),
      );
      await tester.pumpAndSettle();

      expect(done, isTrue);
      expect(await OnboardingService.needsOnboarding(), isFalse);
    },
  );
}
