import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/api_exception.dart';
import 'package:ansor_market_mobile/core/network/dio_client.dart';
import 'package:ansor_market_mobile/features/profile/domain/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_remote_datasource.g.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiConstants.customerGetProfile,
      );
      return ProfileModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ProfileModel> updateProfile({
    required String fullName,
    String? email,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiConstants.customerUpdateProfile,
        data: {
          'fullName': fullName,
          if (email != null) 'email': email,
        },
      );
      return ProfileModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.put<void>(
        ApiConstants.customerChangePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  ApiException _mapError(DioException e) {
    final statusCode = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    final message = (data is Map<String, dynamic>)
        ? (data['message'] as String? ?? e.message ?? 'Unknown error')
        : (e.message ?? 'Unknown error');
    return ApiException(statusCode: statusCode, message: message);
  }
}

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSource(ref.watch(dioProvider));
}
