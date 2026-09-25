import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/business_profile_repository.dart';
import '../domain/business_profile.dart';

/// On-device business profile repository (SharedPreferences JSON document).
final businessProfileRepositoryProvider =
    Provider<BusinessProfileRepository>((ref) {
      return BusinessProfileRepository();
    });

/// The business profile, or null when it hasn't been set up yet.
/// Async because the first load reads from disk.
final businessProfileProvider =
    AsyncNotifierProvider<BusinessProfileNotifier, BusinessProfile?>(
      BusinessProfileNotifier.new,
    );

class BusinessProfileNotifier extends AsyncNotifier<BusinessProfile?> {
  @override
  Future<BusinessProfile?> build() {
    return ref.watch(businessProfileRepositoryProvider).loadProfile();
  }

  Future<void> saveProfile(BusinessProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(businessProfileRepositoryProvider).saveProfile(profile);
      return profile;
    });
  }
}
