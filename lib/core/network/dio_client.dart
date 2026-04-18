import 'package:ansor_market_mobile/core/constants/api_constants.dart';
import 'package:ansor_market_mobile/core/network/logging_interceptor.dart';
import 'package:ansor_market_mobile/core/network/token_interceptor.dart';
import 'package:ansor_market_mobile/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_client.g.dart';

// Notifier for signaling auth failure to go_router
final unauthenticatedProvider = StateProvider<bool>((ref) => false);

@riverpod
Dio dio(Ref ref) {
  final storage = ref.watch(secureStorageProvider);

  final client = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  client.interceptors.add(
    TokenInterceptor(
      storage: storage,
      dio: client,
      onUnauthenticated: () {
        ref.read(unauthenticatedProvider.notifier).state = true;
      },
    ),
  );

  if (kDebugMode) {
    client.interceptors.add(LoggingInterceptor());
  }

  return client;
}
