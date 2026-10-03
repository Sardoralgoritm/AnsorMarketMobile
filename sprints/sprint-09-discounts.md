# Sprint 09 — Discounts & Promo Codes

## Goal
Surface discounts and promo codes throughout the app — on product cards, product detail, and at checkout. Users should clearly see when they're saving money. This sprint wires up the discount display logic and promo code validation.

---

## Backend Context

The domain model already contains: `Discount`, `PromoCode`, `ProductDiscount`. The API endpoints are anticipated but not yet implemented.

---

## Expected API Contract

| Method | Endpoint | Body | Description |
|--------|----------|------|-------------|
| GET | `/api/products/{id}` | — | Already returns price — extend to include `discountedPrice`, `discountPercent` |
| POST | `/api/products/getlist` | — | Extend response to include discount info per product |
| POST | `/api/promo/validate` | `{ code, cartTotal }` | Validate promo code + return discount amount |
| GET | `/api/discounts/active` | — | (Anticipated) List of active promotions for banner |

---

## Model Extensions

Extend `ProductModel`:
```dart
@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    // ... existing fields
    double? discountedPrice,       // null if no discount
    double? discountPercent,       // e.g. 20.0 for 20% off
    DateTime? discountEndsAt,      // countdown timer if set
  }) = _ProductModel;
}
```

Add `PromoResultModel`:
```dart
@freezed
class PromoResultModel with _$PromoResultModel {
  const factory PromoResultModel({
    required String code,
    required double discountAmount,
    required String discountType, // 'percent' | 'fixed'
    required double discountValue,
    double? maxDiscount,
  }) = _PromoResultModel;

  factory PromoResultModel.fromJson(Map<String, dynamic> json) => _$PromoResultModelFromJson(json);
}
```

---

## Discount Display

### Product Card (update Sprint 03)
- If `discountedPrice` is set:
  - Show `discountedPrice` in bold primary color
  - Show original `price` with strikethrough in grey
  - Red badge top-left: "-20%"

### Product Detail (update Sprint 03)
- Same price display as card
- If `discountEndsAt` is set: show countdown timer "Ends in 2h 45m" (updates every second)
- Timer widget uses `StreamProvider` or `Timer.periodic`

### Cart (update Sprint 04)
- Show discounted price per item if applicable
- Show original price with strikethrough
- Summary shows: Subtotal, Discount (red, negative), Total

---

## Promo Code (Checkout — Sprint 07 integration)

The promo code field in checkout (Sprint 07, Step 2) now wires to the real API:

```dart
Future<void> applyPromoCode(String code) async {
  state = state.copyWith(promoLoading: true, promoError: null);
  try {
    final result = await promoRepository.validate(code: code, cartTotal: cartTotal);
    state = state.copyWith(
      promoCode: code,
      promoResult: result,
      promoLoading: false,
    );
    HapticFeedback.lightImpact();
  } on ApiException catch (e) {
    state = state.copyWith(promoError: e.message, promoLoading: false);
    HapticFeedback.vibrate();
  }
}
```

**UX for promo code field:**
- Text field + "Apply" button inline
- Loading: spinner replaces "Apply" button text
- Success: field turns green, checkmark icon, shows "You saved X,XXX UZS"
- Error: field turns red, shake animation, error text below
- Remove: "×" button appears on success to clear the promo code

---

## Promotions Banner

If the `/api/discounts/active` endpoint is available:
- Show a horizontal carousel on the Home screen (existing banner slot from Sprint 03)
- Each banner: gradient background, discount headline, CTA button
- Auto-scroll every 4 seconds with dot indicators
- Tap → navigate to filtered product list with discount

If endpoint not yet available: keep static placeholder banners.

---

## Animations Checklist

- [ ] Discount badge on product card: scale pop-in on load
- [ ] Countdown timer: digit flip animation (AnimatedSwitcher on each digit)
- [ ] Promo code success: field color transition + checkmark slide in
- [ ] Promo code error: shake animation (translate left/right)
- [ ] Savings amount in cart: count-up animation when discount applied

---

## Acceptance Criteria

- [ ] Discounted products show correct prices throughout (card, detail, cart)
- [ ] Discount percentage badge visible on all discounted product cards
- [ ] Countdown timer works for time-limited discounts
- [ ] Valid promo code applies discount at checkout
- [ ] Invalid promo code shows clear error
- [ ] Cart total updates correctly when promo applied
- [ ] Removing promo code reverts total
- [ ] `flutter analyze` returns zero errors
