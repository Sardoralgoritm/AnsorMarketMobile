import 'package:ansor_market_mobile/features/catalog/data/catalog_remote_datasource.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/category_model.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/paginated_result.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/product_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'catalog_repository.g.dart';

class CatalogRepository {
  CatalogRepository(this._dataSource);

  final CatalogRemoteDataSource _dataSource;
  List<CategoryModel>? _categoryTreeCache;

  Future<List<CategoryModel>> getCategoryTree() async {
    _categoryTreeCache ??= await _dataSource.getCategoryTree();
    return _categoryTreeCache!;
  }

  void invalidateCategoryCache() => _categoryTreeCache = null;

  Future<PaginatedResult<CategoryModel>> getCategoryList({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) =>
      _dataSource.getCategoryList(
        page: page,
        pageSize: pageSize,
        search: search,
      );

  Future<CategoryModel> getCategoryById(String id) =>
      _dataSource.getCategoryById(id);

  Future<PaginatedResult<ProductModel>> getProductList({
    required int page,
    required int pageSize,
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
  }) =>
      _dataSource.getProductList(
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
        search: search,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
      );

  Future<ProductModel> getProductById(String id) =>
      _dataSource.getProductById(id);

  Future<ProductModel> getProductBySlug(String slug) =>
      _dataSource.getProductBySlug(slug);
}

@riverpod
CatalogRepository catalogRepository(Ref ref) {
  return CatalogRepository(ref.watch(catalogRemoteDataSourceProvider));
}
