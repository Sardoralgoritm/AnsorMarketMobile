// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductModel _$ProductModelFromJson(Map<String, dynamic> json) =>
    _ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      categoryId: json['categoryId'] as String,
      price: (json['price'] as num).toDouble(),
      images: (json['images'] as List<dynamic>?)
              ?.map(
                  (e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) =>
                  ProductVariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      attributes: (json['attributes'] as List<dynamic>?)
              ?.map((e) =>
                  ProductAttributeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ProductModelToJson(_ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'price': instance.price,
      'images': instance.images,
      'variants': instance.variants,
      'attributes': instance.attributes,
      'isActive': instance.isActive,
    };

_ProductImageModel _$ProductImageModelFromJson(Map<String, dynamic> json) =>
    _ProductImageModel(
      id: json['id'] as String,
      imageKey: json['imageKey'] as String,
      isMain: json['isMain'] as bool,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$ProductImageModelToJson(_ProductImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageKey': instance.imageKey,
      'isMain': instance.isMain,
      'sortOrder': instance.sortOrder,
    };

_ProductVariantModel _$ProductVariantModelFromJson(Map<String, dynamic> json) =>
    _ProductVariantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
    );

Map<String, dynamic> _$ProductVariantModelToJson(
        _ProductVariantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'isAvailable': instance.isAvailable,
    };

_ProductAttributeModel _$ProductAttributeModelFromJson(
        Map<String, dynamic> json) =>
    _ProductAttributeModel(
      name: json['name'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ProductAttributeModelToJson(
        _ProductAttributeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
