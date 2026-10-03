# Sprint 07 — Orders & Checkout

## Goal
Implement the checkout flow and order history. This is the most critical user journey in the app — from cart to confirmed order. It must be frictionless, clear, and confidence-inspiring. The backend order endpoints are not yet implemented; this sprint defines the expected API contract and builds the UI ready to wire up.

---

## Expected API Contract (to be implemented on backend)

These endpoints are anticipated based on the current domain model. Coordinate with backend before implementation.

| Method | Endpoint | Body | Auth | Description |
|--------|----------|------|------|-------------|
| POST | `/api/orders/create` | `{ branchId, addressId, deliveryType, paymentMethod, promoCode? }` | Bearer | Place order from cart |
| GET | `/api/orders/getlist` | `?page=1&pageSize=20` | Bearer | Order history |
| GET | `/api/orders/{id}` | — | Bearer | Order detail |
| POST | `/api/orders/{id}/cancel` | — | Bearer | Cancel order |

---

## Models (anticipated)

```dart
@freezed
class OrderModel with _$OrderModel {
  const factory OrderModel({
    required String id,
    required String status, // pending, confirmed, preparing, delivering, delivered, cancelled
    required List<OrderItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double total,
    String? promoCode,
    double? discount,
    required String branchId,
    required String branchName,
    required String deliveryType, // delivery | pickup
    AddressModel? deliveryAddress,
    required DateTime createdAt,
    DateTime? deliveredAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required String productId,
    required String productName,
    String? imageKey,
    required int quantity,
    required double price,
    String? variantName,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String id,
    required String label,
    required String fullAddress,
    required double latitude,
    required double longitude,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}
```

---

## Checkout Flow (3-step)

### Step 1 — Delivery Options

- Choose delivery type: **Delivery** or **Pickup**
- If Delivery:
  - Show saved addresses (if any)
  - "Add new address" option → opens address form
  - Address form: label (Home/Work/Other), full address text, map pin picker
- If Pickup:
  - Show branch selector (list of branches, similar to Sprint 06 list view)
  - Selected branch highlighted

**UX:** Segmented button at top for Delivery/Pickup. Smooth cross-fade between the two option panels. Address cards with a radio selector. "Continue" button at bottom.

---

### Step 2 — Order Summary

- List of cart items (read-only, compact row format)
- Delivery address or selected branch
- Promo code input field + "Apply" button
  - On valid code: show green checkmark + discount amount
  - On invalid: red inline error "Invalid promo code"
- Price breakdown:
  - Subtotal
  - Delivery fee (or "Free" for pickup)
  - Discount (if promo applied)
  - **Total** (bold, large)
- Payment method selector: Cash on Delivery / Card (placeholder for card)

**UX:** All items in a scrollable view. Promo code field has a clean inline apply button. Price rows animate in. "Place Order" button at bottom (sticky).

---

### Step 3 — Order Confirmation

- Full-screen success state (no AppBar)
- Animated checkmark (Lottie animation or custom animated checkmark with `flutter_animate`)
- "Order Placed!" heading
- Order number displayed
- Estimated delivery time (if returned by API)
- Two buttons: "Track Order" (placeholder) and "Continue Shopping" → pops to Home, clears cart

**UX:** This screen must feel celebratory. The checkmark should animate in smoothly. The order number should appear with a pop. `HapticFeedback.heavyImpact()` on arrival at this screen.

---

## Order History Screen

**Layout:**
- AppBar: "My Orders"
- Paginated list of order cards
- Empty state: "No orders yet" + "Start Shopping" button

**OrderCard Widget:**
- Order number (bold)
- Date (formatted: "April 18, 2026")
- Status chip (color-coded: pending=orange, confirmed=blue, delivered=green, cancelled=grey)
- Item thumbnails (up to 3, overlapping circles style)
- Total amount
- "View Details" → Order Detail screen

---

## Order Detail Screen

**Layout:**
- AppBar: "Order #12345" + share icon
- Status timeline (horizontal or vertical stepper):
  - Placed → Confirmed → Preparing → Delivering → Delivered
  - Current step highlighted, completed steps filled
- Item list (same style as cart items, read-only)
- Delivery info card (address or branch)
- Price breakdown (same as checkout summary)
- "Cancel Order" button (only if status is `pending` or `confirmed`)

**Cancel Order:**
- `AlertDialog`: "Cancel this order?" — Yes/No
- On confirm: call `POST /api/orders/{id}/cancel`
- Status updates in place (optimistic)

---

## State

**`features/orders/presentation/providers/orders_provider.dart`**
```dart
@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  // Paginated list
  Future<void> loadOrders({bool reset = false}) async { ... }
  Future<void> loadMore() async { ... }
}

@riverpod
Future<OrderModel> orderDetail(Ref ref, String id) async { ... }

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  // State: CheckoutState (step, selectedAddress, selectedBranch, deliveryType, promoCode, discount)
  void setDeliveryType(String type) { ... }
  void selectAddress(AddressModel address) { ... }
  void selectBranch(BranchModel branch) { ... }
  Future<void> applyPromoCode(String code) async { ... }
  Future<OrderModel> placeOrder() async { ... }
}
```

---

## Animations Checklist

- [ ] Checkout steps: slide left/right transition between steps
- [ ] Order confirmation: animated checkmark (scale + draw)
- [ ] Order number: pop-in with scale animation
- [ ] Status timeline: animated progress fill
- [ ] Promo code success: check icon slides in
- [ ] Cancel: subtle fade on status chip change

---

## Acceptance Criteria (once backend is ready)

- [ ] Full checkout flow (delivery + pickup) completes successfully
- [ ] Promo code validation works (valid and invalid cases)
- [ ] Order appears in order history after placement
- [ ] Order detail shows correct status and items
- [ ] Cancel works for cancellable orders
- [ ] Cart is cleared after successful order
- [ ] Confirmation screen shows correct order number

> **Note:** Build all UI screens now. Wire to API stubs/mock data until backend endpoints are deployed. Use `FakeOrdersRepository` for development.
