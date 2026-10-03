import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/api_exception.dart';
import 'package:ansor_market_mobile/core/network/dio_client.dart';
import 'package:ansor_market_mobile/features/auth/domain/models/auth_response_model.dart';
import 'package:ansor_market_mobile/features/auth/domain/models/token_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_datasource.g.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> register({
    required String fullName,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.register,
        data: {
          'fullName': fullName,
          'phone': phone,
          'password': password,
        },
      );
      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<AuthResponseModel> login({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: {'phone': phone, 'password': password},
      );
      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<TokenModel> refresh({required String refreshToken}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refresh,
        data: {'refreshToken': refreshToken},
      );
      return TokenModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      await _dio.post<void>(
        ApiConstants.logout,
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ApiException _mapError(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    String message = e.message ?? 'Unknown error';
    if (data is Map<String, dynamic>) {
      // Try API error format: { errors: [{ errorResult: { errorMessage: "..." } }] }
      final errors = data['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map<String, dynamic>) {
          final errorResult = first['errorResult'];
          if (errorResult is Map<String, dynamic>) {
            message = errorResult['errorMessage'] as String? ?? message;
          }
        }
      } else {
        message = data['message'] as String? ?? message;
      }
    }
    return ApiException(statusCode: statusCode, message: message);
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
}
