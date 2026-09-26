import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/email_template.dart';

/// On-device storage for the invoice email template: one JSON document.
/// Corrupt or missing storage yields null (the localized default applies).
class EmailTemplateRepository {
  static const storageKey = 'facture.email_template.v1';

  Future<EmailTemplate?> loadTemplate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return EmailTemplate.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveTemplate(EmailTemplate template) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(template.toJson()));
  }
}
