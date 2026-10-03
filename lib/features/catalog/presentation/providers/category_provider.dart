import 'package:ansor_market_mobile/features/catalog/data/catalog_repository.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_provider.g.dart';

@riverpod
Future<List<CategoryModel>> categoryTree(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).getCategoryTree();
}

@riverpod
class SelectedCategoryNotifier extends _$SelectedCategoryNotifier {
  @override
  CategoryModel? build() => null;

  void select(CategoryModel? category) => state = category;
}
