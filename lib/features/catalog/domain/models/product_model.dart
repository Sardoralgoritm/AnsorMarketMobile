import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
abstract class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    required String categoryId,
    required double price,
    @Default([]) List<ProductImageModel> images,
    @Default([]) List<ProductVariantModel> variants,
    @Default([]) List<ProductAttributeModel> attributes,
    required bool isActive,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}

@freezed
abstract class ProductImageModel with _$ProductImageModel {
  const factory ProductImageModel({
    required String id,
    required String imageKey,
    required bool isMain,
    required int sortOrder,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);
}

@freezed
abstract class ProductVariantModel with _$ProductVariantModel {
  const factory ProductVariantModel({
    required String id,
    required String name,
    required double price,
    required bool isAvailable,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);
}

@freezed
abstract class ProductAttributeModel with _$ProductAttributeModel {
  const factory ProductAttributeModel({
    required String name,
    required String value,
  }) = _ProductAttributeModel;

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeModelFromJson(json);
}
