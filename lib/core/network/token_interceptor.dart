import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/api_exception.dart';
import 'package:ansor_market_mobile/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends QueuedInterceptorsWrapper {
  TokenInterceptor({
    required this.storage,
    required this.dio,
    required this.onUnauthenticated,
  });

  final SecureStorageService storage;
  final Dio dio;
  final void Function() onUnauthenticated;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await dio.post<Map<String, dynamic>>(
            ApiConstants.refresh,
            data: {'refreshToken': refreshToken},
            options: Options(headers: {'Authorization': null}),
          );
          final data = response.data;
          if (data != null) {
            final newAccess = data['accessToken'] as String;
            final newRefresh = data['refreshToken'] as String;
            await storage.saveTokens(access: newAccess, refresh: newRefresh);
            final retried = await dio.fetch<dynamic>(
              err.requestOptions
                ..headers['Authorization'] = 'Bearer $newAccess',
            );
            handler.resolve(retried);
            return;
          }
        } catch (_) {
          // refresh failed — fall through to unauthenticated
        }
      }
      await storage.clearTokens();
      onUnauthenticated();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const ApiException(
            statusCode: 401,
            message: 'Session expired. Please log in again.',
          ),
        ),
      );
      return;
    }
    handler.next(err);
  }
}
