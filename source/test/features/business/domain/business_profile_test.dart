import 'package:facture/features/business/domain/business_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BusinessProfile', () {
    test('defaults to registered with empty fields', () {
      const profile = BusinessProfile();
      expect(profile.taxStatus, TaxRegistrationStatus.registered);
      expect(profile.chargesTaxes, isTrue);
      expect(profile.isSetUp, isFalse);
      expect(profile.hasTaxNumbers, isFalse);
    });

    test('small supplier does not charge taxes', () {
      const profile = BusinessProfile(
        taxStatus: TaxRegistrationStatus.smallSupplier,
      );
      expect(profile.chargesTaxes, isFalse);
    });

    test('isSetUp requires a business name', () {
      expect(const BusinessProfile().isSetUp, isFalse);
      expect(const BusinessProfile(name: '  ').isSetUp, isFalse);
      expect(const BusinessProfile(name: 'Atelier Nord').isSetUp, isTrue);
    });

    test('JSON round-trip preserves every field', () {
      const profile = BusinessProfile(
        name: 'Atelier Nord',
        address: '123 rue Saint-Denis\nMontréal QC',
        phone: '514-555-0101',
        email: 'bonjour@ateliernord.ca',
        taxStatus: TaxRegistrationStatus.smallSupplier,
        tpsNumber: '123456789RT0001',
        tvqNumber: '1234567890TQ0001',
      );
      final restored = BusinessProfile.fromJson(profile.toJson());
      expect(restored, profile);
    });

    test('unknown tax status falls back to registered', () {
      final restored = BusinessProfile.fromJson({
        'name': 'X',
        'taxStatus': 'bogus',
      });
      expect(restored.taxStatus, TaxRegistrationStatus.registered);
    });

    test('missing keys default to empty', () {
      final restored = BusinessProfile.fromJson({});
      expect(restored, const BusinessProfile());
    });
  });
}
