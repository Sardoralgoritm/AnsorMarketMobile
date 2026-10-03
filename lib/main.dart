import 'package:ansor_market_mobile/app.dart';
import 'package:ansor_market_mobile/core/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage.init();
  runApp(const ProviderScope(child: AnsorMarketApp()));
}
