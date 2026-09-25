import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/business_profile.dart';

/// On-device storage for the business profile: one JSON document.
/// Corrupt or missing storage yields null (no profile set up yet).
class BusinessProfileRepository {
  static const storageKey = 'facture.business_profile.v1';

  Future<BusinessProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return BusinessProfile.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(BusinessProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(profile.toJson()));
  }
}
