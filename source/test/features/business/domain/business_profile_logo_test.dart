import 'dart:convert';

import 'package:facture/features/business/domain/business_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusinessProfile logo', () {
    test('logoPath round-trips through JSON', () {
      const profile = BusinessProfile(
        name: 'Atelier Nord',
        logoPath: '/tmp/business-logo.png',
      );
      final restored = BusinessProfile.fromJson(
        jsonDecode(jsonEncode(profile.toJson())) as Map<String, dynamic>,
      );
      expect(restored, profile);
      expect(restored.logoPath, '/tmp/business-logo.png');
    });

    test('logoPath omitted from JSON when absent', () {
      const profile = BusinessProfile(name: 'Atelier Nord');
      final json = profile.toJson();
      expect(json.containsKey('logoPath'), isFalse);
      expect(
        BusinessProfile.fromJson(json).logoPath,
        isNull,
      );
    });

    test('copyWith preserves the logo unless replaced', () {
      const profile = BusinessProfile(
        name: 'Atelier Nord',
        logoPath: '/tmp/a.png',
      );
      expect(profile.copyWith(name: 'Nord').logoPath, '/tmp/a.png');
      expect(profile.copyWith(logoPath: '/tmp/b.png').logoPath, '/tmp/b.png');
    });

    test('withoutLogo clears the logo but keeps the rest', () {
      const profile = BusinessProfile(
        name: 'Atelier Nord',
        logoPath: '/tmp/a.png',
      );
      final cleared = profile.withoutLogo();
      expect(cleared.logoPath, isNull);
      expect(cleared.name, 'Atelier Nord');
    });
  });
}
