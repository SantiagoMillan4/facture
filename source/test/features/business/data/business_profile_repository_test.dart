import 'package:facture/features/business/data/business_profile_repository.dart';
import 'package:facture/features/business/domain/business_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('BusinessProfileRepository', () {
    test('returns null when nothing was saved', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = BusinessProfileRepository();
      expect(await repo.loadProfile(), isNull);
    });

    test('save then load round-trips the profile', () async {
      SharedPreferences.setMockInitialValues({});
      final repo = BusinessProfileRepository();
      const profile = BusinessProfile(
        name: 'Atelier Nord',
        taxStatus: TaxRegistrationStatus.registered,
        tpsNumber: '123456789RT0001',
        tvqNumber: '1234567890TQ0001',
      );
      await repo.saveProfile(profile);
      expect(await repo.loadProfile(), profile);
    });

    test('corrupt storage yields null instead of throwing', () async {
      SharedPreferences.setMockInitialValues({
        BusinessProfileRepository.storageKey: 'not-json{{{',
      });
      final repo = BusinessProfileRepository();
      expect(await repo.loadProfile(), isNull);
    });
  });
}
