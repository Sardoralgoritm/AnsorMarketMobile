import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/api_exception.dart';
import 'package:ansor_market_mobile/core/network/dio_client.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/category_model.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/paginated_result.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_remote_datasource.g.dart';

class CatalogRemoteDataSource {
  CatalogRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CategoryModel>> getCategoryTree() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiConstants.categoriesGetTree,
      );
      return (response.data ?? [])
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<PaginatedResult<CategoryModel>> getCategoryList({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.categoriesGetList,
        data: {
          'page': page,
          'pageSize': pageSize,
          if (search != null) 'search': search,
        },
      );
      final data = response.data!;
      final items = (data['rows'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResult<CategoryModel>(
        items: items,
        totalCount: data['totalRows'] as int,
        page: page,
        pageSize: pageSize,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.categories}/$id',
      );
      return CategoryModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<PaginatedResult<ProductModel>> getProductList({
    required int page,
    required int pageSize,
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.productsGetList,
        data: {
          'page': page,
          'pageSize': pageSize,
          if (categoryId != null) 'categoryId': categoryId,
          if (search != null) 'search': search,
          if (minPrice != null) 'minPrice': minPrice,
          if (maxPrice != null) 'maxPrice': maxPrice,
          if (sortBy != null) 'sortBy': sortBy,
        },
      );
      final data = response.data!;
      final items = (data['rows'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return PaginatedResult<ProductModel>(
        items: items,
        totalCount: data['totalRows'] as int,
        page: page,
        pageSize: pageSize,
      );
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.productsGetById}/$id',
      );
      return ProductModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<ProductModel> getProductBySlug(String slug) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.productsGetById}/$slug',
      );
      return ProductModel.fromJson(response.data!);
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
CatalogRemoteDataSource catalogRemoteDataSource(Ref ref) {
  return CatalogRemoteDataSource(ref.watch(dioProvider));
}
