import 'dart:convert';
import 'dart:io';

import 'package:facture/features/business/application/business_profile_providers.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/logo/presentation/logo_creator_screen.dart';
import 'package:facture/l10n/app_localizations.dart';
import 'package:facture/shared/widgets/app_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../test_helpers.dart';

/// Opens the creator the way Tools does: prefilled with the saved name.
class _Opener extends ConsumerWidget {
  const _Opener();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(businessProfileProvider).value?.name ?? '';
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () =>
              pushAppPage(context, (_) => LogoCreatorScreen(initialName: name)),
          child: const Text('open creator'),
        ),
      ),
    );
  }
}

void main() {
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;
  late ProviderContainer container;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('logo_creator_test');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
          if (call.method == 'getApplicationDocumentsDirectory') {
            return tempDir.path;
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    tempDir.deleteSync(recursive: true);
  });

  bool creatorOpen() => find.byType(LogoCreatorScreen).evaluate().isNotEmpty;
  bool creatorGone() => find.byType(LogoCreatorScreen).evaluate().isEmpty;
  bool imageShown() => find.byType(Image).evaluate().isNotEmpty;

  Future<void> pumpOpener(
    WidgetTester tester, {
    Map<String, Object> prefs = const {},
    bool waitForPreview = false,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return const _Opener();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // With a prefill the creator renders its preview from initState: that
    // render must be awaited in the same runAsync block as the open tap,
    // otherwise the future is stranded when the block exits.
    await doRealAsync(
      tester,
      () => tester.tap(find.text('open creator')),
      waitForPreview ? imageShown : creatorOpen,
      waitForPreview ? 'the logo preview' : 'the creator to open',
    );
  }

  Future<void> enterName(WidgetTester tester, String name) => doRealAsync(
    tester,
    () => tester.enterText(find.byType(TextField), name),
    imageShown,
    'the logo preview',
  );

  Finder saveButton() => find.widgetWithText(OutlinedButton, 'Use this logo');

  testWidgets('save is disabled until a business name is entered', (
    tester,
  ) async {
    await pumpOpener(tester);

    expect(tester.widget<OutlinedButton>(saveButton()).onPressed, isNull);

    await enterName(tester, 'Atelier Nord');

    expect(tester.widget<OutlinedButton>(saveButton()).onPressed, isNotNull);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets(
    'saving without a profile creates a small-supplier profile with the logo',
    (tester) async {
      await pumpOpener(tester);
      await enterName(tester, 'Atelier Nord');

      // Wait for the creator to be gone: the pop transition finishing means
      // _save fully completed (it pops only after persisting). Waiting on
      // the opener text would be racy — it is still in the tree while the
      // opening push transition runs.
      await doRealAsync(
        tester,
        () => tester.tap(saveButton()),
        creatorGone,
        'the creator to close',
      );
      expect(find.text('open creator'), findsOneWidget);

      // The creator pops only after persisting, so the profile is saved here.
      final profile = container.read(businessProfileProvider).value;
      expect(profile, isNotNull);
      expect(profile!.name, 'Atelier Nord');
      // The creator must never silently switch taxes on.
      expect(profile.taxStatus, TaxRegistrationStatus.smallSupplier);
      expect(profile.logoPath, isNotNull);

      final file = File(profile.logoPath!);
      expect(file.existsSync(), isTrue);
      final bytes = file.readAsBytesSync();
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    },
  );

  testWidgets('saving with a profile keeps its name and tax status', (
    tester,
  ) async {
    await pumpOpener(
      tester,
      prefs: {
        'facture.business_profile.v1': jsonEncode({
          'name': 'Atelier Nord',
          'address': '',
          'phone': '',
          'email': '',
          'taxStatus': 'registered',
          'tpsNumber': '',
          'tvqNumber': '',
        }),
      },
      // The prefilled name renders a preview on open.
      waitForPreview: true,
    );

    // Save is already enabled thanks to the prefill.
    expect(tester.widget<OutlinedButton>(saveButton()).onPressed, isNotNull);
    await doRealAsync(
      tester,
      () => tester.tap(saveButton()),
      creatorGone,
      'the creator to close',
    );
    expect(find.text('open creator'), findsOneWidget);

    final profile = container.read(businessProfileProvider).value;
    expect(profile, isNotNull);
    expect(profile!.name, 'Atelier Nord');
    expect(profile.taxStatus, TaxRegistrationStatus.registered);
    expect(profile.logoPath, isNotNull);
    expect(File(profile.logoPath!).existsSync(), isTrue);
  });
}
