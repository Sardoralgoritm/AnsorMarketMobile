import 'package:ansor_market_mobile/app.dart';
import 'package:ansor_market_mobile/core/storage/hive_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app smoke test', (WidgetTester tester) async {
    await HiveStorage.init();
    await tester.pumpWidget(
      const ProviderScope(child: AnsorMarketApp()),
    );
    expect(find.byType(AnsorMarketApp), findsOneWidget);
  });
}
