// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductModel {
  String get id;
  String get name;
  String get slug;
  String? get description;
  String get categoryId;
  String? get categoryName;
  double get price;
  String? get mainImageKey;
  List<ProductImageModel> get images;
  List<ProductVariantModel> get variants;
  List<ProductAttributeModel> get attributes;
  bool get isActive;
  int? get sortOrder;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductModelCopyWith<ProductModel> get copyWith =>
      _$ProductModelCopyWithImpl<ProductModel>(
          this as ProductModel, _$identity);

  /// Serializes this ProductModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.mainImageKey, mainImageKey) ||
                other.mainImageKey == mainImageKey) &&
            const DeepCollectionEquality().equals(other.images, images) &&
            const DeepCollectionEquality().equals(other.variants, variants) &&
            const DeepCollectionEquality()
                .equals(other.attributes, attributes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      categoryId,
      categoryName,
      price,
      mainImageKey,
      const DeepCollectionEquality().hash(images),
      const DeepCollectionEquality().hash(variants),
      const DeepCollectionEquality().hash(attributes),
      isActive,
      sortOrder);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, slug: $slug, description: $description, categoryId: $categoryId, categoryName: $categoryName, price: $price, mainImageKey: $mainImageKey, images: $images, variants: $variants, attributes: $attributes, isActive: $isActive, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) _then) =
      _$ProductModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      String? description,
      String categoryId,
      String? categoryName,
      double price,
      String? mainImageKey,
      List<ProductImageModel> images,
      List<ProductVariantModel> variants,
      List<ProductAttributeModel> attributes,
      bool isActive,
      int? sortOrder});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res> implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._self, this._then);

  final ProductModel _self;
  final $Res Function(ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? categoryId = null,
    Object? categoryName = freezed,
    Object? price = null,
    Object? mainImageKey = freezed,
    Object? images = null,
    Object? variants = null,
    Object? attributes = null,
    Object? isActive = null,
    Object? sortOrder = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: freezed == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      mainImageKey: freezed == mainImageKey
          ? _self.mainImageKey
          : mainImageKey // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _self.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImageModel>,
      variants: null == variants
          ? _self.variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      attributes: null == attributes
          ? _self.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<ProductAttributeModel>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductModel].
extension ProductModelPatterns on ProductModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String slug,
            String? description,
            String categoryId,
            String? categoryName,
            double price,
            String? mainImageKey,
            List<ProductImageModel> images,
            List<ProductVariantModel> variants,
            List<ProductAttributeModel> attributes,
            bool isActive,
            int? sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.description,
            _that.categoryId,
            _that.categoryName,
            _that.price,
            _that.mainImageKey,
            _that.images,
            _that.variants,
            _that.attributes,
            _that.isActive,
            _that.sortOrder);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String name,
            String slug,
            String? description,
            String categoryId,
            String? categoryName,
            double price,
            String? mainImageKey,
            List<ProductImageModel> images,
            List<ProductVariantModel> variants,
            List<ProductAttributeModel> attributes,
            bool isActive,
            int? sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel():
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.description,
            _that.categoryId,
            _that.categoryName,
            _that.price,
            _that.mainImageKey,
            _that.images,
            _that.variants,
            _that.attributes,
            _that.isActive,
            _that.sortOrder);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String name,
            String slug,
            String? description,
            String categoryId,
            String? categoryName,
            double price,
            String? mainImageKey,
            List<ProductImageModel> images,
            List<ProductVariantModel> variants,
            List<ProductAttributeModel> attributes,
            bool isActive,
            int? sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductModel() when $default != null:
        return $default(
            _that.id,
            _that.name,
            _that.slug,
            _that.description,
            _that.categoryId,
            _that.categoryName,
            _that.price,
            _that.mainImageKey,
            _that.images,
            _that.variants,
            _that.attributes,
            _that.isActive,
            _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductModel implements ProductModel {
  const _ProductModel(
      {required this.id,
      required this.name,
      required this.slug,
      this.description,
      required this.categoryId,
      this.categoryName,
      required this.price,
      this.mainImageKey,
      final List<ProductImageModel> images = const [],
      final List<ProductVariantModel> variants = const [],
      final List<ProductAttributeModel> attributes = const [],
      required this.isActive,
      this.sortOrder})
      : _images = images,
        _variants = variants,
        _attributes = attributes;
  factory _ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String categoryId;
  @override
  final String? categoryName;
  @override
  final double price;
  @override
  final String? mainImageKey;
  final List<ProductImageModel> _images;
  @override
  @JsonKey()
  List<ProductImageModel> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<ProductVariantModel> _variants;
  @override
  @JsonKey()
  List<ProductVariantModel> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  final List<ProductAttributeModel> _attributes;
  @override
  @JsonKey()
  List<ProductAttributeModel> get attributes {
    if (_attributes is EqualUnmodifiableListView) return _attributes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_attributes);
  }

  @override
  final bool isActive;
  @override
  final int? sortOrder;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductModelCopyWith<_ProductModel> get copyWith =>
      __$ProductModelCopyWithImpl<_ProductModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.mainImageKey, mainImageKey) ||
                other.mainImageKey == mainImageKey) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            const DeepCollectionEquality()
                .equals(other._attributes, _attributes) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      slug,
      description,
      categoryId,
      categoryName,
      price,
      mainImageKey,
      const DeepCollectionEquality().hash(_images),
      const DeepCollectionEquality().hash(_variants),
      const DeepCollectionEquality().hash(_attributes),
      isActive,
      sortOrder);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, slug: $slug, description: $description, categoryId: $categoryId, categoryName: $categoryName, price: $price, mainImageKey: $mainImageKey, images: $images, variants: $variants, attributes: $attributes, isActive: $isActive, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$ProductModelCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$ProductModelCopyWith(
          _ProductModel value, $Res Function(_ProductModel) _then) =
      __$ProductModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String slug,
      String? description,
      String categoryId,
      String? categoryName,
      double price,
      String? mainImageKey,
      List<ProductImageModel> images,
      List<ProductVariantModel> variants,
      List<ProductAttributeModel> attributes,
      bool isActive,
      int? sortOrder});
}

/// @nodoc
class __$ProductModelCopyWithImpl<$Res>
    implements _$ProductModelCopyWith<$Res> {
  __$ProductModelCopyWithImpl(this._self, this._then);

  final _ProductModel _self;
  final $Res Function(_ProductModel) _then;

  /// Create a copy of ProductModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? categoryId = null,
    Object? categoryName = freezed,
    Object? price = null,
    Object? mainImageKey = freezed,
    Object? images = null,
    Object? variants = null,
    Object? attributes = null,
    Object? isActive = null,
    Object? sortOrder = freezed,
  }) {
    return _then(_ProductModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _self.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: freezed == categoryName
          ? _self.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      mainImageKey: freezed == mainImageKey
          ? _self.mainImageKey
          : mainImageKey // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImageModel>,
      variants: null == variants
          ? _self._variants
          : variants // ignore: cast_nullable_to_non_nullable
              as List<ProductVariantModel>,
      attributes: null == attributes
          ? _self._attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as List<ProductAttributeModel>,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: freezed == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$ProductImageModel {
  String get id;
  String get imageKey;
  bool get isMain;
  int get sortOrder;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductImageModelCopyWith<ProductImageModel> get copyWith =>
      _$ProductImageModelCopyWithImpl<ProductImageModel>(
          this as ProductImageModel, _$identity);

  /// Serializes this ProductImageModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductImageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageKey, imageKey) ||
                other.imageKey == imageKey) &&
            (identical(other.isMain, isMain) || other.isMain == isMain) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageKey, isMain, sortOrder);

  @override
  String toString() {
    return 'ProductImageModel(id: $id, imageKey: $imageKey, isMain: $isMain, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class $ProductImageModelCopyWith<$Res> {
  factory $ProductImageModelCopyWith(
          ProductImageModel value, $Res Function(ProductImageModel) _then) =
      _$ProductImageModelCopyWithImpl;
  @useResult
  $Res call({String id, String imageKey, bool isMain, int sortOrder});
}

/// @nodoc
class _$ProductImageModelCopyWithImpl<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  _$ProductImageModelCopyWithImpl(this._self, this._then);

  final ProductImageModel _self;
  final $Res Function(ProductImageModel) _then;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageKey = null,
    Object? isMain = null,
    Object? sortOrder = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageKey: null == imageKey
          ? _self.imageKey
          : imageKey // ignore: cast_nullable_to_non_nullable
              as String,
      isMain: null == isMain
          ? _self.isMain
          : isMain // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductImageModel].
extension ProductImageModelPatterns on ProductImageModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductImageModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductImageModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductImageModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String imageKey, bool isMain, int sortOrder)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
        return $default(
            _that.id, _that.imageKey, _that.isMain, _that.sortOrder);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String imageKey, bool isMain, int sortOrder)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel():
        return $default(
            _that.id, _that.imageKey, _that.isMain, _that.sortOrder);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String imageKey, bool isMain, int sortOrder)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductImageModel() when $default != null:
        return $default(
            _that.id, _that.imageKey, _that.isMain, _that.sortOrder);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductImageModel implements ProductImageModel {
  const _ProductImageModel(
      {required this.id,
      required this.imageKey,
      required this.isMain,
      required this.sortOrder});
  factory _ProductImageModel.fromJson(Map<String, dynamic> json) =>
      _$ProductImageModelFromJson(json);

  @override
  final String id;
  @override
  final String imageKey;
  @override
  final bool isMain;
  @override
  final int sortOrder;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductImageModelCopyWith<_ProductImageModel> get copyWith =>
      __$ProductImageModelCopyWithImpl<_ProductImageModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductImageModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductImageModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageKey, imageKey) ||
                other.imageKey == imageKey) &&
            (identical(other.isMain, isMain) || other.isMain == isMain) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageKey, isMain, sortOrder);

  @override
  String toString() {
    return 'ProductImageModel(id: $id, imageKey: $imageKey, isMain: $isMain, sortOrder: $sortOrder)';
  }
}

/// @nodoc
abstract mixin class _$ProductImageModelCopyWith<$Res>
    implements $ProductImageModelCopyWith<$Res> {
  factory _$ProductImageModelCopyWith(
          _ProductImageModel value, $Res Function(_ProductImageModel) _then) =
      __$ProductImageModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String imageKey, bool isMain, int sortOrder});
}

/// @nodoc
class __$ProductImageModelCopyWithImpl<$Res>
    implements _$ProductImageModelCopyWith<$Res> {
  __$ProductImageModelCopyWithImpl(this._self, this._then);

  final _ProductImageModel _self;
  final $Res Function(_ProductImageModel) _then;

  /// Create a copy of ProductImageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? imageKey = null,
    Object? isMain = null,
    Object? sortOrder = null,
  }) {
    return _then(_ProductImageModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageKey: null == imageKey
          ? _self.imageKey
          : imageKey // ignore: cast_nullable_to_non_nullable
              as String,
      isMain: null == isMain
          ? _self.isMain
          : isMain // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ProductVariantModel {
  String get id;
  String get name;
  double get price;
  bool get isAvailable;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductVariantModelCopyWith<ProductVariantModel> get copyWith =>
      _$ProductVariantModelCopyWithImpl<ProductVariantModel>(
          this as ProductVariantModel, _$identity);

  /// Serializes this ProductVariantModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductVariantModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, isAvailable);

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, name: $name, price: $price, isAvailable: $isAvailable)';
  }
}

/// @nodoc
abstract mixin class $ProductVariantModelCopyWith<$Res> {
  factory $ProductVariantModelCopyWith(
          ProductVariantModel value, $Res Function(ProductVariantModel) _then) =
      _$ProductVariantModelCopyWithImpl;
  @useResult
  $Res call({String id, String name, double price, bool isAvailable});
}

/// @nodoc
class _$ProductVariantModelCopyWithImpl<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  _$ProductVariantModelCopyWithImpl(this._self, this._then);

  final ProductVariantModel _self;
  final $Res Function(ProductVariantModel) _then;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? isAvailable = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _self.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductVariantModel].
extension ProductVariantModelPatterns on ProductVariantModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductVariantModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductVariantModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductVariantModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String name, double price, bool isAvailable)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
        return $default(_that.id, _that.name, _that.price, _that.isAvailable);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String name, double price, bool isAvailable)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel():
        return $default(_that.id, _that.name, _that.price, _that.isAvailable);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String name, double price, bool isAvailable)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductVariantModel() when $default != null:
        return $default(_that.id, _that.name, _that.price, _that.isAvailable);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductVariantModel implements ProductVariantModel {
  const _ProductVariantModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.isAvailable});
  factory _ProductVariantModel.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  @override
  final bool isAvailable;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductVariantModelCopyWith<_ProductVariantModel> get copyWith =>
      __$ProductVariantModelCopyWithImpl<_ProductVariantModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductVariantModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductVariantModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, isAvailable);

  @override
  String toString() {
    return 'ProductVariantModel(id: $id, name: $name, price: $price, isAvailable: $isAvailable)';
  }
}

/// @nodoc
abstract mixin class _$ProductVariantModelCopyWith<$Res>
    implements $ProductVariantModelCopyWith<$Res> {
  factory _$ProductVariantModelCopyWith(_ProductVariantModel value,
          $Res Function(_ProductVariantModel) _then) =
      __$ProductVariantModelCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, double price, bool isAvailable});
}

/// @nodoc
class __$ProductVariantModelCopyWithImpl<$Res>
    implements _$ProductVariantModelCopyWith<$Res> {
  __$ProductVariantModelCopyWithImpl(this._self, this._then);

  final _ProductVariantModel _self;
  final $Res Function(_ProductVariantModel) _then;

  /// Create a copy of ProductVariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? isAvailable = null,
  }) {
    return _then(_ProductVariantModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _self.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isAvailable: null == isAvailable
          ? _self.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$ProductAttributeModel {
  String get name;
  String get value;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProductAttributeModelCopyWith<ProductAttributeModel> get copyWith =>
      _$ProductAttributeModelCopyWithImpl<ProductAttributeModel>(
          this as ProductAttributeModel, _$identity);

  /// Serializes this ProductAttributeModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProductAttributeModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  @override
  String toString() {
    return 'ProductAttributeModel(name: $name, value: $value)';
  }
}

/// @nodoc
abstract mixin class $ProductAttributeModelCopyWith<$Res> {
  factory $ProductAttributeModelCopyWith(ProductAttributeModel value,
          $Res Function(ProductAttributeModel) _then) =
      _$ProductAttributeModelCopyWithImpl;
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class _$ProductAttributeModelCopyWithImpl<$Res>
    implements $ProductAttributeModelCopyWith<$Res> {
  _$ProductAttributeModelCopyWithImpl(this._self, this._then);

  final ProductAttributeModel _self;
  final $Res Function(ProductAttributeModel) _then;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ProductAttributeModel].
extension ProductAttributeModelPatterns on ProductAttributeModel {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProductAttributeModel value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductAttributeModel() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProductAttributeModel value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAttributeModel():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProductAttributeModel value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAttributeModel() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String name, String value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProductAttributeModel() when $default != null:
        return $default(_that.name, _that.value);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String name, String value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAttributeModel():
        return $default(_that.name, _that.value);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String name, String value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProductAttributeModel() when $default != null:
        return $default(_that.name, _that.value);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ProductAttributeModel implements ProductAttributeModel {
  const _ProductAttributeModel({required this.name, required this.value});
  factory _ProductAttributeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductAttributeModelFromJson(json);

  @override
  final String name;
  @override
  final String value;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProductAttributeModelCopyWith<_ProductAttributeModel> get copyWith =>
      __$ProductAttributeModelCopyWithImpl<_ProductAttributeModel>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProductAttributeModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProductAttributeModel &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value);

  @override
  String toString() {
    return 'ProductAttributeModel(name: $name, value: $value)';
  }
}

/// @nodoc
abstract mixin class _$ProductAttributeModelCopyWith<$Res>
    implements $ProductAttributeModelCopyWith<$Res> {
  factory _$ProductAttributeModelCopyWith(_ProductAttributeModel value,
          $Res Function(_ProductAttributeModel) _then) =
      __$ProductAttributeModelCopyWithImpl;
  @override
  @useResult
  $Res call({String name, String value});
}

/// @nodoc
class __$ProductAttributeModelCopyWithImpl<$Res>
    implements _$ProductAttributeModelCopyWith<$Res> {
  __$ProductAttributeModelCopyWithImpl(this._self, this._then);

  final _ProductAttributeModel _self;
  final $Res Function(_ProductAttributeModel) _then;

  /// Create a copy of ProductAttributeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? value = null,
  }) {
    return _then(_ProductAttributeModel(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
