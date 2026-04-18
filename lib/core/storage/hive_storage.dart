import 'package:hive_flutter/hive_flutter.dart';

class HiveStorage {
  static const _settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_settingsBox);
  }

  static Box<String> get settings => Hive.box<String>(_settingsBox);
}
