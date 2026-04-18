import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_exception.freezed.dart';

@freezed
abstract class ApiException with _$ApiException implements Exception {
  const factory ApiException({
    required int statusCode,
    required String message,
    String? errorCode,
  }) = _ApiException;
}
