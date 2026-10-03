# Sprint 03 — Catalog (Categories & Products)

## Goal
Build the full product browsing experience: category tree navigation, paginated product lists with filtering, and a rich product detail screen. This is the core of the app — it must be fast, visually appealing, and feel like a premium shopping experience.

---

## API Endpoints

| Method | Endpoint | Body / Query | Description |
|--------|----------|-------------|-------------|
| GET | `/api/categories/gettree` | — | Full hierarchical category tree |
| POST | `/api/categories/getlist` | `{ page, pageSize, search? }` | Paginated flat category list |
| GET | `/api/categories/{id}` | — | Single category |
| POST | `/api/products/getlist` | `{ page, pageSize, categoryId?, search?, minPrice?, maxPrice?, sortBy? }` | Paginated products |
| GET | `/api/products/{id}` | — | Product detail by ID |
| GET | `/api/products/{slug}` | — | Product detail by slug |

---

## Models

**`features/catalog/domain/models/category_model.dart`**
```dart
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    required String slug,
    String? parentId,
    String? imageKey,
    required bool isActive,
    required int sortOrder,
    @Default([]) List<CategoryModel> children, // for tree structure
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
}
```

**`features/catalog/domain/models/product_model.dart`**
```dart
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required String id,
    required String name,
    required String slug,
    String? description,
    required String categoryId,
    required double price,
    @Default([]) List<ProductImageModel> images,
    @Default([]) List<ProductVariantModel> variants,
    @Default([]) List<ProductAttributeModel> attributes,
    required bool isActive,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
}

@freezed
class ProductImageModel with _$ProductImageModel {
  const factory ProductImageModel({
    required String id,
    required String imageKey,
    required bool isMain,
    required int sortOrder,
  }) = _ProductImageModel;

  factory ProductImageModel.fromJson(Map<String, dynamic> json) => _$ProductImageModelFromJson(json);
}

@freezed
class ProductVariantModel with _$ProductVariantModel {
  const factory ProductVariantModel({
    required String id,
    required String name,
    required double price,
    required bool isAvailable,
  }) = _ProductVariantModel;

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) => _$ProductVariantModelFromJson(json);
}

@freezed
class ProductAttributeModel with _$ProductAttributeModel {
  const factory ProductAttributeModel({
    required String name,
    required String value,
  }) = _ProductAttributeModel;

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) => _$ProductAttributeModelFromJson(json);
}
```

**`features/catalog/domain/models/paginated_result.dart`**
```dart
@freezed
class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    required List<T> items,
    required int totalCount,
    required int page,
    required int pageSize,
  }) = _PaginatedResult<T>;
}
```

---

## Data Layer

**`features/catalog/data/catalog_remote_datasource.dart`**

```dart
// Methods:
Future<List<CategoryModel>> getCategoryTree();
Future<PaginatedResult<CategoryModel>> getCategoryList({int page = 1, int pageSize = 20, String? search});
Future<CategoryModel> getCategoryById(String id);
Future<PaginatedResult<ProductModel>> getProductList({
  required int page,
  required int pageSize,
  String? categoryId,
  String? search,
  double? minPrice,
  double? maxPrice,
  String? sortBy,
});
Future<ProductModel> getProductById(String id);
Future<ProductModel> getProductBySlug(String slug);
```

**`features/catalog/data/catalog_repository.dart`**

Wraps datasource, adds in-memory caching for the category tree (rarely changes).

---

## State

**`features/catalog/presentation/providers/category_provider.dart`**

```dart
@riverpod
Future<List<CategoryModel>> categoryTree(Ref ref) async {
  return ref.watch(catalogRepositoryProvider).getCategoryTree();
}

@riverpod
class SelectedCategoryNotifier extends _$SelectedCategoryNotifier {
  // Holds currently selected category for filtering
  // State: CategoryModel?
  void select(CategoryModel? category) => state = category;
}
```

**`features/catalog/presentation/providers/product_provider.dart`**

```dart
@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  // State: AsyncValue<PaginatedResult<ProductModel>>
  // Supports: initial load, load more (pagination), refresh, filter change

  int _page = 1;
  bool _hasMore = true;
  List<ProductModel> _items = [];

  String? _categoryId;
  String? _search;
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'default';

  Future<void> load({bool reset = false}) async { ... }
  Future<void> loadMore() async { ... }
  void applyFilters({String? categoryId, String? search, double? minPrice, double? maxPrice, String? sortBy}) { ... }
}

@riverpod
Future<ProductModel> productDetail(Ref ref, String id) async {
  return ref.watch(catalogRepositoryProvider).getProductById(id);
}
```

---

## Screens

### Home Screen

**Layout:**
- Search bar at top (tappable → navigates to Search screen, Sprint 08)
- Horizontal scrollable category chips (top categories from tree root)
- Banner/carousel (promotional, static images for now — placeholder)
- "Popular Products" section heading + horizontal scrollable row of product cards
- "All Products" grid below with infinite scroll
- Bottom navigation bar

**UX details:**
- Category chips animate in with staggered fade (30ms between each)
- Product cards use `Hero` animation tagged with product ID
- Tapping a category chip filters the product grid immediately (optimistic, show loading skeleton per card)
- `CachedNetworkImage` with fade-in for all images
- Pull-to-refresh refreshes both categories and products

---

### Category Tree Screen

**Layout:**
- AppBar: "Categories"
- Root categories displayed as large tiles with image and name
- Tapping a root category expands to show subcategories (animated expand/collapse)
- Subcategories listed as smaller tiles
- Tapping any category navigates to Product List filtered by that category

**UX details:**
- Animated expand/collapse using `AnimatedSize` or `flutter_animate`
- Active/selected category highlighted with primary color border
- Breadcrumb trail at top when inside a subcategory

---

### Product List Screen

**Layout:**
- AppBar with category name + filter icon
- Sticky filter/sort bar below AppBar (scrolls away then sticks)
- Grid of product cards (2 columns on phone, 3 on tablet)
- Infinite scroll: on reaching bottom 20% → load next page
- Loading more indicator at bottom (small spinner row)

**Product Card Widget (`shared/widgets/product_card.dart`):**
- Product image (main image, `CachedNetworkImage`, aspect ratio 1:1)
- Product name (2 lines max, overflow ellipsis)
- Price (bold, primary color)
- Discount badge if applicable (top-left corner, red pill)
- Add to cart button (bottom right, `+` icon) — triggers haptic + brief scale animation
- Hero animation tag: `'product_${product.id}'`

**Filter Bottom Sheet:**
- Triggered by filter icon in AppBar
- Price range slider
- Sort by: Newest, Price ↑, Price ↓, Popular
- Category selector (if opened from home)
- "Apply Filters" button + "Reset" text button
- Bottom sheet slides up with `showModalBottomSheet` + `isScrollControlled: true`

**Skeleton loading:**
- Show 6 shimmer card placeholders while first page loads
- Each placeholder matches exact dimensions of a real product card

---

### Product Detail Screen

**Layout:**
- Full-screen image gallery at top (PageView with dot indicators)
  - Hero animation on main image
  - Pinch-to-zoom support
  - Swipe through images
- Floating back button over the image (no AppBar)
- Scrollable body below:
  - Product name (large, bold)
  - Price (large, primary color)
  - Rating row (placeholder stars for now)
  - Short description (expandable "Read more" if > 3 lines)
  - Attributes section (key-value chips: e.g., "Color: Red", "Weight: 500g")
  - Variants section (if variants exist): pill buttons to select variant
  - Quantity selector: [-] [2] [+] with haptic on each tap
  - Long description (expandable)
- Sticky bottom bar (always visible above keyboard/safe area):
  - Total price (updates when quantity/variant changes)
  - "Add to Cart" button (full width, primary color)
  - If item already in cart: show "In Cart (x2)" with green indicator + option to go to cart

**UX details:**
- Image gallery swipe is buttery smooth — use `PageView` with `physics: BouncingScrollPhysics()`
- "Add to Cart" button does a quick scale bounce animation then shows checkmark (500ms) before reverting
- Haptic `HapticFeedback.mediumImpact()` on "Add to Cart"
- Variant selection animates the selected pill (scale + color)
- Price updates with a brief fade when variant changes
- Share button in app bar (placeholder)
- Breadcrumb: "Home > Category > Product Name" at top of scroll body

---

## Shared ProductCard Widget

Used on Home, Product List, and any future "related products" section.

```dart
class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  // ...
}
```

Must handle:
- Missing image gracefully (placeholder icon)
- Long product names (2-line clamp)
- Price formatting via `CurrencyFormatter`

---

## Animations Checklist

- [ ] Category chips: staggered fade-in on screen enter
- [ ] Product cards: staggered fade+slide-up on first load
- [ ] Hero animation: product image list → detail
- [ ] Category tree expand/collapse: `AnimatedSize`
- [ ] Filter bottom sheet: slide up
- [ ] Add to cart button: scale bounce + checkmark crossfade
- [ ] Variant selection: scale + color transition
- [ ] Image gallery: smooth PageView swipe

---

## Acceptance Criteria

- [ ] Category tree loads and renders hierarchically
- [ ] Products load paginated — more load on scroll
- [ ] Filtering by category works
- [ ] Price and sort filters work
- [ ] Product detail shows all images, variants, attributes
- [ ] Add to cart works (Sprint 04 must be done first for full flow, but button must not crash)
- [ ] Hero animation plays smoothly between list and detail
- [ ] Shimmer placeholders show during loading
- [ ] Pull-to-refresh works on all list screens
- [ ] `flutter analyze` returns zero errors
