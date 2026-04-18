import 'package:ansor_market_mobile/features/catalog/data/catalog_repository.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_provider.g.dart';

const _pageSize = 20;

@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  int _page = 1;
  bool _hasMore = true;
  List<ProductModel> _items = [];

  String? _categoryId;
  String? _search;
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'default';

  @override
  AsyncValue<List<ProductModel>> build() => const AsyncData([]);

  Future<void> load({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasMore = true;
      _items = [];
      state = const AsyncLoading();
    }

    if (!_hasMore) return;

    try {
      final result = await ref.read(catalogRepositoryProvider).getProductList(
            page: _page,
            pageSize: _pageSize,
            categoryId: _categoryId,
            search: _search,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            sortBy: _sortBy == 'default' ? null : _sortBy,
          );

      _items = reset ? result.items : [..._items, ...result.items];
      _hasMore = result.hasMore;
      _page++;
      state = AsyncData(List.unmodifiable(_items));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;
    await load();
  }

  void applyFilters({
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) {
    _categoryId = categoryId;
    _search = search;
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    _sortBy = sortBy ?? 'default';
    load(reset: true);
  }

  bool get hasMore => _hasMore;
}

@riverpod
Future<ProductModel> productDetail(Ref ref, String id) async {
  return ref.watch(catalogRepositoryProvider).getProductById(id);
}
