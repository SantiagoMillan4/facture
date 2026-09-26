import 'package:shared_preferences/shared_preferences.dart';

import '../../business/data/business_profile_repository.dart';

/// First-launch onboarding state.
///
/// Shown once: on a fresh install with no business profile yet. Returning
/// users (a profile is already set up, e.g. after an app update) skip the
/// flow silently and are marked done.
class OnboardingService {
  /// SharedPreferences flag marking the flow complete. Public so tests can
  /// seed a returning user (a fresh install must see onboarding instead).
  static const doneKey = 'facture.onboarding_done.v1';

  static Future<bool> needsOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(doneKey) == true) return false;
    final profile = await BusinessProfileRepository().loadProfile();
    if (profile != null && profile.isSetUp) {
      await prefs.setBool(doneKey, true);
      return false;
    }
    return true;
  }

  static Future<void> markDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(doneKey, true);
  }
}
