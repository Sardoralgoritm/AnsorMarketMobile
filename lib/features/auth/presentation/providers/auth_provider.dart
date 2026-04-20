import 'package:ansor_market_mobile/core/storage/secure_storage.dart';
import 'package:ansor_market_mobile/features/auth/data/auth_repository.dart';
import 'package:ansor_market_mobile/features/auth/domain/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  UserModel? build() => null;

  Future<bool> restoreSession() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.getAccessToken();
    if (token == null) return false;
    final profile = await storage.getProfile();
    if (profile == null) return false;
    state = UserModel(
      id: profile.phone,
      fullName: profile.fullName,
      phone: profile.phone,
    );
    return true;
  }

  Future<void> login(String phone, String password) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(phone: phone, password: password);
    state = UserModel(
      id: result.phone,
      fullName: result.fullName,
      phone: result.phone,
    );
  }

  Future<void> register(
    String fullName,
    String phone,
    String password,
  ) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.register(
      fullName: fullName,
      phone: phone,
      password: password,
    );
    state = UserModel(
      id: result.phone,
      fullName: result.fullName,
      phone: result.phone,
    );
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = null;
  }

  void clearUser() => state = null;
}
