import 'package:ansor_market_mobile/core/storage/secure_storage.dart';
import 'package:ansor_market_mobile/features/auth/data/auth_remote_datasource.dart';
import 'package:ansor_market_mobile/features/auth/domain/models/auth_response_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._dataSource, this._storage);

  final AuthRemoteDataSource _dataSource;
  final SecureStorageService _storage;

  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  }) async {
    final result = await _dataSource.login(phone: phone, password: password);
    await _storage.saveTokens(
      access: result.accessToken,
      refresh: result.refreshToken,
    );
    await _storage.saveProfile(fullName: result.fullName, phone: result.phone);
    return result;
  }

  Future<AuthResponseModel> register({
    required String fullName,
    required String phone,
    required String password,
  }) async {
    final result = await _dataSource.register(
      fullName: fullName,
      phone: phone,
      password: password,
    );
    await _storage.saveTokens(
      access: result.accessToken,
      refresh: result.refreshToken,
    );
    await _storage.saveProfile(fullName: result.fullName, phone: result.phone);
    return result;
  }

  Future<void> logout() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken != null) {
      await _dataSource.logout(refreshToken: refreshToken);
    }
    await _storage.clearTokens();
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageProvider),
  );
}
