// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApiException {
  int get statusCode;
  String get message;
  String? get errorCode;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ApiExceptionCopyWith<ApiException> get copyWith =>
      _$ApiExceptionCopyWithImpl<ApiException>(
          this as ApiException, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ApiException &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message, errorCode);

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, errorCode: $errorCode)';
  }
}

/// @nodoc
abstract mixin class $ApiExceptionCopyWith<$Res> {
  factory $ApiExceptionCopyWith(
          ApiException value, $Res Function(ApiException) _then) =
      _$ApiExceptionCopyWithImpl;
  @useResult
  $Res call({int statusCode, String message, String? errorCode});
}

/// @nodoc
class _$ApiExceptionCopyWithImpl<$Res> implements $ApiExceptionCopyWith<$Res> {
  _$ApiExceptionCopyWithImpl(this._self, this._then);

  final ApiException _self;
  final $Res Function(ApiException) _then;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statusCode = null,
    Object? message = null,
    Object? errorCode = freezed,
  }) {
    return _then(_self.copyWith(
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ApiException].
extension ApiExceptionPatterns on ApiException {
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
    TResult Function(_ApiException value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ApiException() when $default != null:
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
    TResult Function(_ApiException value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApiException():
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
    TResult? Function(_ApiException value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApiException() when $default != null:
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
    TResult Function(int statusCode, String message, String? errorCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ApiException() when $default != null:
        return $default(_that.statusCode, _that.message, _that.errorCode);
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
    TResult Function(int statusCode, String message, String? errorCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApiException():
        return $default(_that.statusCode, _that.message, _that.errorCode);
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
    TResult? Function(int statusCode, String message, String? errorCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ApiException() when $default != null:
        return $default(_that.statusCode, _that.message, _that.errorCode);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ApiException implements ApiException {
  const _ApiException(
      {required this.statusCode, required this.message, this.errorCode});

  @override
  final int statusCode;
  @override
  final String message;
  @override
  final String? errorCode;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ApiExceptionCopyWith<_ApiException> get copyWith =>
      __$ApiExceptionCopyWithImpl<_ApiException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ApiException &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, statusCode, message, errorCode);

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, message: $message, errorCode: $errorCode)';
  }
}

/// @nodoc
abstract mixin class _$ApiExceptionCopyWith<$Res>
    implements $ApiExceptionCopyWith<$Res> {
  factory _$ApiExceptionCopyWith(
          _ApiException value, $Res Function(_ApiException) _then) =
      __$ApiExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({int statusCode, String message, String? errorCode});
}

/// @nodoc
class __$ApiExceptionCopyWithImpl<$Res>
    implements _$ApiExceptionCopyWith<$Res> {
  __$ApiExceptionCopyWithImpl(this._self, this._then);

  final _ApiException _self;
  final $Res Function(_ApiException) _then;

  /// Create a copy of ApiException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? statusCode = null,
    Object? message = null,
    Object? errorCode = freezed,
  }) {
    return _then(_ApiException(
      statusCode: null == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errorCode: freezed == errorCode
          ? _self.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
