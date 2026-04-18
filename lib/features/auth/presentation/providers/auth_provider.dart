import 'package:ansor_market_mobile/features/auth/data/auth_repository.dart';
import 'package:ansor_market_mobile/features/auth/domain/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  UserModel? build() => null;

  Future<void> login(String phone, String password) async {
    final repo = ref.read(authRepositoryProvider);
    final result = await repo.login(phone: phone, password: password);
    state = result.user;
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
    state = result.user;
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = null;
  }

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}
