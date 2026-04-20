import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

abstract class SecureStorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const fullName = 'full_name';
  static const phone = 'phone';
}

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> getAccessToken() =>
      _storage.read(key: SecureStorageKeys.accessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: SecureStorageKeys.refreshToken);

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: SecureStorageKeys.accessToken, value: access);
    await _storage.write(key: SecureStorageKeys.refreshToken, value: refresh);
  }

  Future<void> saveProfile({
    required String fullName,
    required String phone,
  }) async {
    await _storage.write(key: SecureStorageKeys.fullName, value: fullName);
    await _storage.write(key: SecureStorageKeys.phone, value: phone);
  }

  Future<({String fullName, String phone})?> getProfile() async {
    final fullName = await _storage.read(key: SecureStorageKeys.fullName);
    final phone = await _storage.read(key: SecureStorageKeys.phone);
    if (fullName == null || phone == null) return null;
    return (fullName: fullName, phone: phone);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: SecureStorageKeys.accessToken);
    await _storage.delete(key: SecureStorageKeys.refreshToken);
    await _storage.delete(key: SecureStorageKeys.fullName);
    await _storage.delete(key: SecureStorageKeys.phone);
  }
}

@riverpod
SecureStorageService secureStorage(Ref ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return SecureStorageService(storage);
}
