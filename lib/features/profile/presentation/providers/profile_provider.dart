import 'package:ansor_market_mobile/features/profile/data/profile_repository.dart';
import 'package:ansor_market_mobile/features/profile/domain/models/profile_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  AsyncValue<ProfileModel> build() => const AsyncLoading();

  Future<void> loadProfile() async {
    state = const AsyncLoading();
    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateProfile(String fullName, String? email) async {
    try {
      final updated = await ref
          .read(profileRepositoryProvider)
          .updateProfile(fullName: fullName, email: email);
      state = AsyncData(updated);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await ref.read(profileRepositoryProvider).changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
  }
}
