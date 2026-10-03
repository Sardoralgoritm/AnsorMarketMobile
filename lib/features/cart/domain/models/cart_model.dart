import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
abstract class CartModel with _$CartModel {
  const CartModel._();

  const factory CartModel({
    required List<CartItemModel> items,
    required double totalAmount,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  static CartModel empty() => const CartModel(items: [], totalAmount: 0);
}

@freezed
abstract class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String id,
    required String productId,
    required String productName,
    required double price,
    required int quantity,
    String? imageKey,
    String? variantId,
    String? variantName,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
