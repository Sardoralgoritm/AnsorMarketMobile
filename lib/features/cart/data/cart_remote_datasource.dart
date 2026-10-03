import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/api_exception.dart';
import 'package:ansor_market_mobile/core/network/dio_client.dart';
import 'package:ansor_market_mobile/features/cart/domain/models/cart_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_remote_datasource.g.dart';

class CartRemoteDataSource {
  CartRemoteDataSource(this._dio);

  final Dio _dio;

  Future<CartModel> getCart() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>(ApiConstants.cartGetCart);
      return CartModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<CartModel> addItem({
    required String productId,
    String? variantId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.cartAddItem,
        data: {
          'productId': productId,
          if (variantId != null) 'variantId': variantId,
          'quantity': quantity,
        },
      );
      return CartModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<CartModel> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '${ApiConstants.cart}/$itemId/updateitem',
        data: {'quantity': quantity},
      );
      return CartModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<CartModel> removeItem({required String itemId}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>(
        '${ApiConstants.cart}/$itemId/removeitem',
      );
      return CartModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> clearCart() async {
    try {
      await _dio.delete<void>(ApiConstants.cartClear);
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
CartRemoteDataSource cartRemoteDataSource(Ref ref) {
  return CartRemoteDataSource(ref.watch(dioProvider));
}
