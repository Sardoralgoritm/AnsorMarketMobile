import 'package:ansor_market_mobile/features/profile/data/profile_remote_datasource.dart';
import 'package:ansor_market_mobile/features/profile/domain/models/profile_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._dataSource);

  final ProfileRemoteDataSource _dataSource;
  ProfileModel? _cache;

  Future<ProfileModel> getProfile() async {
    _cache ??= await _dataSource.getProfile();
    return _cache!;
  }

  void invalidateCache() => _cache = null;

  Future<ProfileModel> updateProfile({
    required String fullName,
    String? email,
  }) async {
    final updated =
        await _dataSource.updateProfile(fullName: fullName, email: email);
    _cache = updated;
    return updated;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) =>
      _dataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository(ref.watch(profileRemoteDataSourceProvider));
}
