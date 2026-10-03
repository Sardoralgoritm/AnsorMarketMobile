import 'package:ansor_market_mobile/features/cart/data/cart_remote_datasource.dart';
import 'package:ansor_market_mobile/features/cart/domain/models/cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_repository.g.dart';

class CartRepository {
  CartRepository(this._dataSource);

  final CartRemoteDataSource _dataSource;

  Future<CartModel> getCart() => _dataSource.getCart();

  Future<CartModel> addItem({
    required String productId,
    String? variantId,
    required int quantity,
  }) =>
      _dataSource.addItem(
        productId: productId,
        variantId: variantId,
        quantity: quantity,
      );

  Future<CartModel> updateItem({
    required String itemId,
    required int quantity,
  }) =>
      _dataSource.updateItem(itemId: itemId, quantity: quantity);

  Future<CartModel> removeItem({required String itemId}) =>
      _dataSource.removeItem(itemId: itemId);

  Future<void> clearCart() => _dataSource.clearCart();
}

@riverpod
CartRepository cartRepository(Ref ref) {
  return CartRepository(ref.watch(cartRemoteDataSourceProvider));
}
