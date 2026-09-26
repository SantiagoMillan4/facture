import 'dart:convert';

import 'package:facture/features/business/data/business_profile_repository.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:facture/features/onboarding/application/onboarding_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // SharedPreferences is channel-backed even in pure-Dart tests.
  TestWidgetsFlutterBinding.ensureInitialized();

  Map<String, Object> profilePrefs(String name) => {
    BusinessProfileRepository.storageKey: jsonEncode(
      BusinessProfile(name: name).toJson(),
    ),
  };

  test('needs onboarding on a fresh install', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await OnboardingService.needsOnboarding(), isTrue);
  });

  test('does not need onboarding once marked done', () async {
    SharedPreferences.setMockInitialValues({});
    await OnboardingService.markDone();
    expect(await OnboardingService.needsOnboarding(), isFalse);
  });

  test(
    'returning users with a profile skip silently and are marked done',
    () async {
      SharedPreferences.setMockInitialValues(profilePrefs('Atelier Nord'));
      expect(await OnboardingService.needsOnboarding(), isFalse);
      // The flag was persisted: the next check short-circuits on it.
      expect(await OnboardingService.needsOnboarding(), isFalse);
    },
  );

  test('a profile without a name still needs onboarding', () async {
    SharedPreferences.setMockInitialValues(profilePrefs(''));
    expect(await OnboardingService.needsOnboarding(), isTrue);
  });
}
