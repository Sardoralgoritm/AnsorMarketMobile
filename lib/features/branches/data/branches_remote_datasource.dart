import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/api_exception.dart';
import 'package:ansor_market_mobile/core/network/dio_client.dart';
import 'package:ansor_market_mobile/features/branches/domain/models/branch_model.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/paginated_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branches_remote_datasource.g.dart';

class BranchesRemoteDataSource {
  BranchesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<PaginatedResult<BranchModel>> getBranchList({
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.branchesGetList,
        data: {'page': page, 'pageSize': pageSize},
      );
      final data = response.data!;
      final items = (data['items'] as List<dynamic>)
          .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResult<BranchModel>(
        items: items,
        totalCount: data['totalCount'] as int,
        page: page,
        pageSize: pageSize,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<BranchModel> getBranchById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.branches}/$id',
      );
      return BranchModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<List<BranchModel>> getBranchesInRange({
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiConstants.branchesInRange,
        queryParameters: {'lat': lat, 'lng': lng},
      );
      return (response.data ?? [])
          .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList();
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
BranchesRemoteDataSource branchesRemoteDataSource(Ref ref) {
  return BranchesRemoteDataSource(ref.watch(dioProvider));
}
