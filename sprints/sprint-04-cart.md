# Sprint 04 — Cart

## Goal
Build the cart feature: add/remove/update items, view cart summary, and provide a smooth, responsive experience with optimistic UI updates. The cart icon in the bottom nav must always show the correct item count badge in real time.

---

## API Endpoints

| Method | Endpoint | Body | Auth | Description |
|--------|----------|------|------|-------------|
| GET | `/api/cart/getcart` | — | Bearer | Get current cart |
| POST | `/api/cart/additem` | `{ productId, variantId?, quantity }` | Bearer | Add or increment item |
| PUT | `/api/cart/{itemId}/updateitem` | `{ quantity }` | Bearer | Set item quantity |
| DELETE | `/api/cart/{itemId}/removeitem` | — | Bearer | Remove item |
| DELETE | `/api/cart/clear` | — | Bearer | Clear cart |

---

## Models

**`features/cart/domain/models/cart_model.dart`**
```dart
@freezed
class CartModel with _$CartModel {
  const factory CartModel({
    required List<CartItemModel> items,
    required double totalAmount,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);

  // Computed helpers (const extension or factory):
  // int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required String id,
    required String productId,
    required String productName,
    required double price,
    required int quantity,
    String? imageKey,
    String? variantId,
    String? variantName,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
}
```

---

## Data Layer

**`features/cart/data/cart_remote_datasource.dart`**

```dart
Future<CartModel> getCart();
Future<CartModel> addItem({required String productId, String? variantId, required int quantity});
Future<CartModel> updateItem({required String itemId, required int quantity});
Future<CartModel> removeItem({required String itemId});
Future<void> clearCart();
```

All endpoints return the updated cart state (or the server returns the cart after mutation — if not, re-fetch after each mutation).

---

## State

**`features/cart/presentation/providers/cart_provider.dart`**

```dart
@riverpod
class CartNotifier extends _$CartNotifier {
  // State: AsyncValue<CartModel>

  Future<void> loadCart() async { ... }

  // Optimistic UI: update local state immediately, revert on error
  Future<void> addItem(String productId, {String? variantId, int quantity = 1}) async {
    // 1. Optimistically add item to local state
    // 2. Call API
    // 3. On success: replace local state with server response
    // 4. On error: revert local state, show error snackbar, haptic vibrate
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    // If quantity == 0, call removeItem instead
    // Optimistic update
  }

  Future<void> removeItem(String itemId) async {
    // Optimistic remove
  }

  Future<void> clearCart() async { ... }
}

// Convenience provider for badge count
@riverpod
int cartItemCount(Ref ref) {
  return ref.watch(cartNotifierProvider).maybeWhen(
    data: (cart) => cart.items.fold(0, (s, i) => s + i.quantity),
    orElse: () => 0,
  );
}

// Check if specific product is in cart (for product detail screen)
@riverpod
CartItemModel? cartItemForProduct(Ref ref, String productId) {
  return ref.watch(cartNotifierProvider).maybeWhen(
    data: (cart) => cart.items.where((i) => i.productId == productId).firstOrNull,
    orElse: () => null,
  );
}
```

Cart is loaded once when the user is authenticated and kept in memory. Mutations go optimistic → server confirm.

---

## Screens

### Cart Screen

**Layout:**
- AppBar: "My Cart" + trash icon (clear all, with confirmation dialog)
- List of cart items (vertical ListView)
- Sticky bottom summary panel:
  - Item count: "3 items"
  - Total amount (large, bold)
  - "Proceed to Checkout" button (full width, primary)

**CartItem Row Widget:**
- Product image (60×60, rounded corners, `CachedNetworkImage`)
- Product name (bold, 2 lines max)
- Variant name if applicable (small, secondary color)
- Price per item
- Quantity control: [-] [count] [+]
  - [-] disabled (but visible) when quantity = 1 — tap shows swipe-to-delete hint
  - When quantity reaches 0 via [-], item is removed with a slide-out animation
- Swipe-to-delete gesture (right-to-left reveals red delete background)
- Individual item total (quantity × price, right-aligned)

**Empty state:**
- Illustration (shopping cart outline)
- "Your cart is empty"
- "Browse Products" button → navigate to catalog

**UX details:**
- Quantity [-]/[+] buttons trigger `HapticFeedback.selectionClick()`
- Item removal: slide out left + collapse height animation (300ms)
- Item added (from product detail): brief "Added to cart" bottom snackbar
- Total price animates (count-up) when quantity changes
- "Clear Cart" shows `AlertDialog` with warning before proceeding
- If user is not logged in and taps "Add to Cart" anywhere: show bottom sheet prompt to log in

---

## Bottom Nav Badge

The cart tab in the bottom navigation bar shows a red badge with the item count.

```dart
// In bottom_nav_bar.dart
Consumer(
  builder: (context, ref, _) {
    final count = ref.watch(cartItemCountProvider);
    return Badge(
      isLabelVisible: count > 0,
      label: Text(count > 99 ? '99+' : '$count'),
      child: Icon(Icons.shopping_cart_outlined),
    );
  },
)
```

Badge animates in/out with scale transition when count changes.

---

## Product Detail Integration (update Sprint 03)

On the Product Detail screen:
- Watch `cartItemForProductProvider(product.id)`
- If item exists: show "In Cart (x2)" with a green badge + "Go to Cart" link
- If not: show "Add to Cart" button
- On "Add to Cart" tap:
  1. `HapticFeedback.mediumImpact()`
  2. Button animates: scale down → scale up → shows checkmark (500ms) → reverts
  3. Call `cartNotifier.addItem(...)`
  4. Cart badge in bottom nav updates immediately (optimistic)

---

## Unauthenticated Cart Behavior

- Guest users can browse but cannot add to cart
- On "Add to Cart" tap when not logged in:
  - Show bottom sheet: "Sign in to add items to your cart"
  - Two buttons: "Sign In" → /login, "Register" → /register
  - Dismiss on tap outside

---

## Animations Checklist

- [ ] Item addition: slide in from right (if navigating from product detail) or from bottom
- [ ] Item removal: slide out left + height collapse
- [ ] Quantity change: price total animates (AnimatedSwitcher or count-up)
- [ ] Cart badge: scale in/out on count change
- [ ] Add to cart button on product detail: scale bounce + checkmark
- [ ] Empty state: fade in when last item removed

---

## Acceptance Criteria

- [ ] Cart loads on screen entry
- [ ] Adding an item from product detail updates cart instantly (optimistic)
- [ ] Quantity increase/decrease works and syncs with server
- [ ] Item swipe-to-delete works
- [ ] Clear cart with confirmation works
- [ ] Cart badge in bottom nav always reflects current count
- [ ] Unauthenticated users see login prompt instead of add-to-cart
- [ ] Empty state shows when cart is empty
- [ ] Error on API call reverts optimistic update and shows error message
- [ ] `flutter analyze` returns zero errors
